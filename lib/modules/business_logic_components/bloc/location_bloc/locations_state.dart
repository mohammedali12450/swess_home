
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';

abstract class LocationsState {}

class LocationsFetchNone extends LocationsState {}

class LocationsFetchError extends LocationsState {}

class LocationsFetchProgress extends LocationsState {}

class LocationsFetchComplete extends LocationsState {

  final List<Location> locations;

  LocationsFetchComplete({required this.locations});

  List<LocationViewer> getLocationsViewers(String? pattern) {
    pattern ??= "";
    List<LocationViewer> result = [];
    for (Location parentLocation in locations) {
      if (parentLocation.locations == null) continue;
      for (Location childLocation in parentLocation.locations!) {
        if (childLocation.name.contains(pattern) || parentLocation.name.contains(pattern) || (pattern == "")) {
          result.add(LocationViewer(
              childLocation.name, parentLocation.name, childLocation.id));
        }
      }
    }
    return result;
  }
}


