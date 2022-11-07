import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/locations_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchLocationScreen extends StatefulWidget {
  static const String id = "SearchLocationScreen";

  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  ChannelCubit patternCubit = ChannelCubit(null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: AppColors.white),
            cursorColor: Theme.of(context).colorScheme.background,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enter_location_name,
              hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: AppColors.white.withOpacity(0.64),
                  fontWeight: FontWeight.w400),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.background),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.background),
              ),
            ),
            onChanged: (value) {
              patternCubit.setState(value);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (_, locationsFetchState) {
              if (locationsFetchState is LocationsFetchProgress) {
                return const LocationsShimmer();
              }
              if (locationsFetchState is LocationsFetchError) {}
              if (locationsFetchState is LocationsFetchComplete) {
                return BlocBuilder<ChannelCubit, dynamic>(
                  bloc: patternCubit,
                  builder: (_, pattern) {
                    List<LocationViewer> locations =
                        locationsFetchState.getLocationsViewers(pattern);
                    return ListView.separated(
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, locations.elementAt(index));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            width: 1.sw,
                            child: Text(
                              locations.elementAt(index).getLocationName(),
                              textAlign: TextAlign.right,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return const Divider();
                      },
                      itemCount: locations.length,
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
