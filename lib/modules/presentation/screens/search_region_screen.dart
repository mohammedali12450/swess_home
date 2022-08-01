import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/locations_shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SearchRegionScreen extends StatefulWidget {
  static const String id = "SearchLocationScreen";

  const SearchRegionScreen({Key? key}) : super(key: key);

  @override
  _SearchRegionScreenState createState() => _SearchRegionScreenState();
}

class _SearchRegionScreenState extends State<SearchRegionScreen> {
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
              hintStyle: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: AppColors.white.withOpacity(0.64), fontWeight: FontWeight.w400),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.background),
              ),
            ),
            onChanged: (value) {
              patternCubit.setState(value);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w , vertical: 12.h),
          child: BlocBuilder<RegionsBloc, RegionsState>(
            builder: (_, regionsFetchState) {
              if (regionsFetchState is RegionsFetchProgress) {
                return const LocationsShimmer();
              }
              if (regionsFetchState is RegionsFetchError) {}
              if (regionsFetchState is RegionsFetchComplete) {
                return BlocBuilder<ChannelCubit, dynamic>(
                  bloc: patternCubit,
                  builder: (_, pattern) {
                    List<RegionViewer> locations = regionsFetchState.getRegionsViewers(pattern);
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
                              locations.elementAt(index).getRegionName(),
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
