import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectCurrentLocation extends StatefulWidget {
  const SelectCurrentLocation({Key? key}) : super(key: key);

  @override
  State<SelectCurrentLocation> createState() => _SelectCurrentLocationState();
}

class _SelectCurrentLocationState extends State<SelectCurrentLocation> {
  Position? _currentPosition;
  late final LatLng _initialPosition =
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

  late Set<Marker> markers = {
    Marker(
      markerId: const MarkerId("1"),
      position: _initialPosition,
    )
  };
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
        );
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              _cameraPosition == null
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: GoogleMap(
                        mapType: MapType.normal,
                        minMaxZoomPreference:
                            const MinMaxZoomPreference(16.0, 19.0),
                        initialCameraPosition: _cameraPosition!,
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        onTap: (latLng) {
                          setState(() {
                            markers
                                .remove(const Marker(markerId: MarkerId("1")));
                            markers.add(Marker(
                                markerId: const MarkerId("1"),
                                position: latLng));
                          });
                        },
                        markers: markers,
                        onCameraMove: (CameraPosition position) {},
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
