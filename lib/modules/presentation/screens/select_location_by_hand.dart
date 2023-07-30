import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/location_bloc/locations_state.dart';

class SelectLocationByHand extends StatefulWidget {
  const SelectLocationByHand({Key? key}) : super(key: key);

  @override
  State<SelectLocationByHand> createState() => _SelectLocationByHandState();
}

class _SelectLocationByHandState extends State<SelectLocationByHand> {
  Position? _currentPosition;
  late LatLng _initialPosition =
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

  late Set<Polygon> polygons = {};

  CameraPosition? _cameraPosition;
  late GoogleMapController _mapController;

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
            zoom: 14.0);
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsBloc, LocationsState>(
      builder: (context, state) {
        if (state is LocationsFetchComplete) {
          List zones = state.zones;
          for (int i = 0; i < zones.length; i++) {
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
        }
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Stack(
                children: [
                  _cameraPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: GoogleMap(
                            onTap: (latLng) {
                              setState(() {
                                _initialPosition = latLng;
                              });
                            },
                            mapType: MapType.terrain,
                            minMaxZoomPreference:
                                const MinMaxZoomPreference(15.5, 15.5),
                            initialCameraPosition: _cameraPosition!,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            indoorViewEnabled: true,
                            mapToolbarEnabled: false,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                            // markers: marker,
                            polygons: polygons,
                          ),
                        ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        _mapController.animateCamera(CameraUpdate.newLatLng(
                            const LatLng(
                                33.50661923766096, 36.28609696204509)));
                      },
                      child: const Text("Get to Damascus"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
