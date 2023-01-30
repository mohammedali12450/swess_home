import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class RegionsState {}

class RegionsFetchNone extends RegionsState {}

class RegionsFetchError extends RegionsState {}

class RegionsFetchProgress extends RegionsState {}

class RegionsFetchComplete extends RegionsState {
  final List<Location> locations;

  RegionsFetchComplete({required this.locations});

  List<RegionViewer> getRegionsViewers(String? pattern, context) {
    pattern ??= "";
    List<RegionViewer> result = [];
    result.add(RegionViewer(AppLocalizations.of(context)!.undefined, "", null));
    for (Location parentLocation in locations) {
      if (parentLocation.locations == null) continue;
      for (Location childLocation in parentLocation.locations!) {
        if (childLocation.name.contains(pattern) ||
            parentLocation.name.contains(pattern) ||
            (pattern == "")) {
          result.add(RegionViewer(
              childLocation.name, parentLocation.name, childLocation.id));
        }
      }
    }
    return result;
  }
}
