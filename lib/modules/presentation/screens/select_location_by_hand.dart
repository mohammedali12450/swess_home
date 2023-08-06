import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swesshome/modules/presentation/screens/filter_search_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_state.dart';

class SelectLocationByHand extends StatefulWidget {
  const SelectLocationByHand({Key? key}) : super(key: key);

  @override
  State<SelectLocationByHand> createState() => _SelectLocationByHandState();
}

class _SelectLocationByHandState extends State<SelectLocationByHand> {
  Position? _currentPosition;
  CameraPosition? _cameraPosition;
  late GoogleMapController _mapController;
  final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyDHy4EQDxFt3S9pJynYC-ovSJylUaONzZs');
  late Set<Polygon> polygons = {};
  late Set<Marker> markers = {};
  List regionsNames = [];
  late List<BitmapDescriptor> customMarker = [];
  List<Map<String, dynamic>> neighborhoodNames = [];
  final TextEditingController searchController = TextEditingController();

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _cameraPosition = CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        );
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<BitmapDescriptor> createCustomMarkerBitmap(String text) async {
    const double fontSize = 35.0;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final double width = textPainter.width + 15.0;
    const double height = 40.0;
    final Paint paint = Paint()..color = Colors.white.withOpacity(0.5);
    final RRect rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, width, height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rRect, paint);
    final Offset textOffset = Offset(
      (width - textPainter.width) / 2,
      (height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);

    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), height.toInt());

    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List imageData = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(imageData);
  }

  Future<void> buildRegionNameMark(List regions) async {
    customMarker = [];
    for (int i = 0; i < regions.length; i++) {
      customMarker.add(await createCustomMarkerBitmap(regions[i]));
    }
  }

  void searchPlaces(String query) async {
    PlacesSearchResponse response = await _places.searchByText(query);

    PlacesSearchResult result = response.results[0];

    PlacesDetailsResponse details =
    await _places.getDetailsByPlaceId(result.placeId);

    LatLng position =
    LatLng(details.result.geometry!.location.lat, details.result.geometry!.location.lng);

    _mapController.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc, LocationsState>(
        builder: (context, state) {
      if (state is LocationsFetchComplete) {
        List zones = state.zones;
        neighborhoodNames = [];
        for (int i = 0; i < zones.length; i++) {
          regionsNames.add(zones[i].name);
          neighborhoodNames.add({
            "id": zones[i].location.id,
            "name": zones[i].location.locationFullName,
          });
          polygons.add(
            Polygon(
              polygonId: PolygonId(zones[i].id.toString()),
              points: zones[i].coordinates!,
              fillColor: HexColor(zones[i].color).withOpacity(0.5),
              strokeColor: HexColor(zones[i].color),
              strokeWidth: 3,
            ),
          );
        }
        buildRegionNameMark(regionsNames);
        regionsNames = [];
      }
      return Scaffold(
        body: SafeArea(
          child: _cameraPosition == null ?
          const Center(child: CircularProgressIndicator()) : Center(
            child: Stack(
              children: [
                Center(
                        child: GoogleMap(
                          mapType: MapType.terrain,
                          minMaxZoomPreference: const MinMaxZoomPreference(16.0, 17.5),
                          initialCameraPosition: _cameraPosition!,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          polygons: polygons,
                          markers: markers,
                          onCameraMove: (CameraPosition position) {},
                          onCameraIdle: () {
                            setState(() {
                              markers = buildMarker();
                            });
                          },
                        ),
                      ),
                Positioned(
                  top: 25.0,
                  left: 16.0,
                  right: 16.0,
                  child: TextFormField(
                  controller: searchController,
                  onFieldSubmitted: (String query){
                    searchPlaces(query);
                  },
                    style: const TextStyle(
                      color: AppColors.black
                    ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(15),
                      fillColor: AppColors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: AppColors.lastColor),
                        borderRadius: BorderRadius.circular(11.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.white),

                      ),
                      prefixIcon: const Icon(Icons.search,color: AppColors.lastColor,),
                      hintText: AppLocalizations.of(context)!.map_location_search,
                      hintStyle: TextStyle(
                        color: AppColors.lightGreyColor,
                      )),
                ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Set<Marker> buildMarker() {
    Set<Marker> markers = {};
    List.generate(polygons.length, (index) {
      Polygon polygon = polygons.elementAt(index);
      LatLng center = LatLng(
        polygon.points.map((point) => point.latitude).reduce((x, y) => x + y) /
            polygon.points.length,
        polygon.points.map((point) => point.longitude).reduce((x, y) => x + y) /
            polygon.points.length,
      );
      markers.add(
        Marker(
            markerId: MarkerId("$index"),
            position: center,
            icon: customMarker[index],
            anchor: const Offset(0.5, 0.5),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FilterSearchScreen(
                        name: neighborhoodNames[index]['name'],
                        id: neighborhoodNames[index]['id']);
                  },
                ),
              );
            }),
      );
    });
    return markers.toSet();
  }
}
