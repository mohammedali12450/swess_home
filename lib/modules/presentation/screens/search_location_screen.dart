import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/modules/presentation/widgets/shimmers/locations_shimmer.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

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
          backgroundColor: AppColors.secondaryColor,
          automaticallyImplyLeading: false,
          title: TextField(
            textDirection: TextDirection.rtl,
            style: textStyling(S.s14, W.w4, C.wh).copyWith(height: 1.8),
            decoration: InputDecoration(
                border: kUnderlinedBorderWhite,
                focusedBorder: kUnderlinedBorderWhite,
                enabledBorder: kUnderlinedBorderWhite,
                hintText: "أدخل اسم المنطقة",
                hintTextDirection: TextDirection.rtl,
                hintStyle: textStyling(S.s14, W.w4, C.whHint),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.baseColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                )),
            onChanged: (value) {
              patternCubit.setState(value);
            },
          ),
        ),
        body: BlocBuilder<LocationsBloc, LocationsState>(
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
                      BlocProvider.of<LocationsBloc>(context)
                          .getLocationsViewers(pattern);
                  return Container(
                    padding: kMediumSymHeight,
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, locations.elementAt(index));
                          },
                          child: Container(
                            margin:
                                EdgeInsets.symmetric(vertical: Res.height(8)),
                            padding: kMediumSymWidth,
                            width: inf,
                            child: ResText(
                              locations.elementAt(index).getLocationName(),
                              textAlign: TextAlign.right,
                              textStyle: textStyling(S.s16, W.w5, C.bl),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return const Divider();
                      },
                      itemCount: locations.length,
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
