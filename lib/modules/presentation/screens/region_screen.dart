import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../business_logic_components/bloc/location_bloc/locations_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_event.dart';
import '../../business_logic_components/bloc/regions_bloc/regions_state.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';

class RegionScreen extends StatefulWidget {
  RegionScreen(
      {required this.locationController,
      required this.isPressSearchCubit,
      this.isArea = true,
      required this.locationId,
      Key? key})
      : super(key: key);
  TextEditingController locationController;
  ChannelCubit isPressSearchCubit;
  bool isArea;
  ChannelCubit? locationId;

  @override
  State<RegionScreen> createState() => _RegionScreenState();
}

class _RegionScreenState extends State<RegionScreen> {
  ChannelCubit patternCubit = ChannelCubit(null);

  RegionsBloc regionsBloc = RegionsBloc();

  @override
  Widget build(BuildContext context) {
    //widget.locationId!.state == null ? 0 : widget.locationId;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64.h),
          child: Container(
            margin: EdgeInsets.only(
              bottom: 8.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
            ),
            child: Center(
              child: TextFormField(
                validator: (value) => value == null
                    ? AppLocalizations.of(context)!.this_field_is_required
                    : null,
                // readOnly: locationDetectedCubit.state,
                onTap: () {
                  widget.locationController.clear();
                  // locationDetectedCubit.setState(false);
                  patternCubit.setState(null);
                  FocusScope.of(context).unfocus();

                  if (widget.locationController.text.isEmpty) {
                    patternCubit.setState("");
                    return;
                  }
                },
                controller: widget.locationController,
                textDirection: TextDirection.rtl,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: AppColors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                  ),
                  border: kUnderlinedBorderWhite,
                  focusedBorder: kUnderlinedBorderWhite,
                  enabledBorder: kUnderlinedBorderWhite,
                  hintText:
                      AppLocalizations.of(context)!.enter_neighborhood_name,
                  hintStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: AppColors.white.withOpacity(0.48),
                      ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    regionsBloc.add(SearchRegionCleared());
                    return;
                  } else {
                    patternCubit.setState(value);
                  }
                },
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<RegionsBloc, RegionsState>(
        builder: (_, regionsFetchState) {
          if (regionsFetchState is RegionsFetchComplete) {
            return BlocBuilder<ChannelCubit, dynamic>(
              bloc: patternCubit,
              builder: (_, pattern) {
                List? locations;
                if (!widget.isArea) {
                  locations = BlocProvider.of<LocationsBloc>(context)
                      .getLocationsViewers(pattern, context);
                } else {
                  locations = BlocProvider.of<RegionsBloc>(context)
                      .getRegionsViewers(pattern, context);
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () async {
                        //set location name in location text field:
                        widget.locationController.text =
                            locations!.elementAt(index).getLocationName();
                        // print(locations.elementAt(index).locationName);
                        // set search data location id:
                        widget.locationId!.setState(locations.elementAt(index).id);
                        //print("i am ghina ${widget.locationId!.state}");
                        // unfocused text field :
                        FocusScope.of(context).unfocus();
                        // save location as recent search:
                        //TODO : add recent search to data base
                        // await saveAsRecentSearch(
                        //     locations.elementAt(index).id!);

                        widget.isPressSearchCubit.setState(true);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 8.h,
                        ),
                        padding: kMediumSymWidth,
                        width: inf,
                        child: Text(
                          locations!.elementAt(index).getLocationName(),
                          textAlign: TextAlign.right,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
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
    );
  }
}
