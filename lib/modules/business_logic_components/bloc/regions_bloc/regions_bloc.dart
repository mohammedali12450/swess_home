import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_state.dart';
import 'package:swesshome/modules/data/models/location.dart';
import 'package:swesshome/modules/data/repositories/locations_repository.dart';
import 'package:swesshome/modules/data/repositories/regions_repository.dart';

class RegionsBloc extends Bloc<RegionsEvent, RegionsState> {
  RegionsRepository regionsRepository = RegionsRepository();
  List<Location>? locations;

  RegionsBloc() : super(RegionsFetchNone()) {
    on<RegionsFetchStarted>((event, emit) async {
      emit(RegionsFetchProgress());
      try {
        locations = await regionsRepository.getRegions();
        emit(RegionsFetchComplete(locations: locations!));
      } catch (e, stack) {
        debugPrint(e.toString());
        debugPrint(stack.toString());
      }
    });
    on<SearchRegionCleared>((event, emit) {
      emit(
        RegionsFetchNone(),
      );
    });
  }

  List<RegionViewer> getRegionsViewers(String? pattern) {
    pattern ??= "";
    List<RegionViewer> result = [];
    result.add(RegionViewer("غير محدد", "غير محدد", null));
    for (Location parentLocation in locations ?? []) {
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

class RegionViewer {
  String locationName;

  String parentLocationName;

  int? id;

  RegionViewer(this.locationName, this.parentLocationName, this.id);

  String getRegionName() {
    return parentLocationName + ' , ' + locationName;
  }
}
