import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';

abstract class RegionsState {}

class RegionsFetchNone extends RegionsState {}

class RegionsFetchError extends RegionsState {}

class RegionsFetchProgress extends RegionsState {}

class RegionsFetchComplete extends RegionsState {

  final List<Location> locations;

  RegionsFetchComplete({required this.locations});

  List<RegionViewer> getRegionsViewers(String? pattern) {
    pattern ??= "";
    List<RegionViewer> result = [];
    for (Location parentLocation in locations) {
      if (parentLocation.locations == null) continue;
      for (Location childLocation in parentLocation.locations!) {
        if (childLocation.name.contains(pattern)) {
          result.add(RegionViewer(
              childLocation.name, parentLocation.name, childLocation.id));
        }
      }
    }
    return result;
  }
}


