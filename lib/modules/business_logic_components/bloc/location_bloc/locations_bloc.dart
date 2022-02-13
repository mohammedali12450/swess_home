import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/repositories/locations_repository.dart';
import 'locations_event.dart';
import 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsRepository locationsRepository = LocationsRepository();
  List<Location>? locations;

  LocationsBloc() : super(LocationsFetchNone()) {
    on<LocationsFetchStarted>((event, emit) async {
      emit(LocationsFetchProgress());
      try {
        locations = await locationsRepository.getLocations();
        emit(LocationsFetchComplete());
      } catch (e , stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
  }

  List<LocationViewer> getLocationsViewers(String? pattern) {
    pattern ??= "";
    List<LocationViewer> result = [];
    for (Location parentLocation in locations??[]) {
      if (parentLocation.locations == null) continue;
      for (Location childLocation in parentLocation.locations!) {
        if (childLocation.name.contains(pattern)|| (pattern == "")) {
          result.add(LocationViewer(
              childLocation.name, parentLocation.name, childLocation.id));
        }
      }
    }
    return result;
  }

}

class LocationViewer {
  String locationName;

  String parentLocationName;

  int id;

  LocationViewer(this.locationName, this.parentLocationName, this.id);

  String getLocationName() {
    return parentLocationName + ' , ' + locationName;
  }
}
