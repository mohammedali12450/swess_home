import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../data/models/zone_model.dart';
abstract class LocationsState {}

class LocationsFetchNone extends LocationsState {}

class LocationsFetchError extends LocationsState {}

class LocationsFetchProgress extends LocationsState {}

class LocationsFetchComplete extends LocationsState {
  final List<Location> locations;
  final List<Zone> zones;

  LocationsFetchComplete({required this.locations, required this.zones});

  List<LocationViewer> getLocationsViewers(String? pattern, context) {
    pattern ??= "";
    List<LocationViewer> result = [];
    result
        .add(LocationViewer(AppLocalizations.of(context)!.undefined, "", null));
    for (Location parentLocation in locations) {
      if (parentLocation.locations == null) continue;
      for (Location childLocation in parentLocation.locations!) {
        if (childLocation.name.contains(pattern) ||
            parentLocation.name.contains(pattern) ||
            (pattern == "")) {
          result.add(LocationViewer(
              childLocation.name, parentLocation.name, childLocation.id));
        }
      }
    }
    return result;
  }
}
