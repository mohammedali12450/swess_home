import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import 'package:swesshome/modules/data/models/estate_type.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/application_constants.dart';
import '../../../constants/assets_paths.dart';
import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/models/search_data.dart';
import '../../data/providers/theme_provider.dart';

class EstateTypeWidget extends StatefulWidget {
  final ChannelCubit isPressTypeCubit;
  final SearchData searchData;
  final bool removeSelect;
  final EstateTypesByLocationBloc? estateTypesByLocationBloc;
  final bool isForSearch;
  const EstateTypeWidget({
    required this.searchData,
    required this.isPressTypeCubit,
    required this.removeSelect,
    Key? key,
    this.estateTypesByLocationBloc, required this.isForSearch,
  }) : super(key: key);

  @override
  State<EstateTypeWidget> createState() => _EstateTypeWidgetState();
}

class _EstateTypeWidgetState extends State<EstateTypeWidget> {
  late bool isDark;
  List<EstateType>? estatesTypes;
  // EstateTypesByLocationBloc estateTypesByLocationBloc =
  //     EstateTypesByLocationBloc(EstateTypesRepository());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.home_outlined),
            kWi8,
            ResText(
              "${AppLocalizations.of(context)!.estate_type} :",
              textStyle: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
        kHe12,
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: widget.isPressTypeCubit,
          builder: (_, pressState) {
            //nabeel
            return widget.isForSearch?
             BlocBuilder<EstateTypesByLocationBloc, EstateTypesState>(
                bloc: widget.estateTypesByLocationBloc,
                builder: (context, estateType) {
                  if (estateType is EstateTypesFetchNone ){
                    return SizedBox();
                  }
                  if (estateType is EstateTypesFetchError) {
                    return SpinKitWave(
                      color: AppColors.blue,
                      size: 20.w,
                    );
                  } else if (estateType is EstateTypesFetchProgress) {
                    return SpinKitWave(
                      color: AppColors.blue,
                      size: 20.w,
                    );
                  } else if (estateType is EstateTypesFetchComplete) {
                    if (estateType.estateTypes!.isEmpty) {
                      return SizedBox();
                    }
                    return SizedBox(
                      height: 110.h,
                      child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return kWi12;
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: estateType.estateTypes!.length,
                          itemBuilder: (context, index) {
                            var iconPath = estateType.estateTypes![index].name
                                .toString()
                                .split("|")
                                .first ==
                                "House" ||
                                estateType.estateTypes![index].name.toString().split("|").first ==
                                    "بيت"
                                ? buildIconPath
                                : estateType.estateTypes![index].name.toString().split("|").first == "Shop" ||
                                estateType.estateTypes![index].name
                                    .toString()
                                    .split("|")
                                    .first ==
                                    "محل"
                                ? shopIconPath
                                : estateType.estateTypes![index].name.toString().split("|").first == "Farm" ||
                                estateType.estateTypes![index].name
                                    .toString()
                                    .split("|")
                                    .first ==
                                    "مزرعة"
                                ? farmIconPath
                                : estateType.estateTypes![index].name.toString().split("|").first == "Land" ||
                                estateType.estateTypes![index]
                                    .name
                                    .toString()
                                    .split("|")
                                    .first ==
                                    "أرض"
                                ? landIconPath
                                : villaIconPath;

                            return Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (widget.removeSelect &&
                                      pressState < 5 &&
                                      pressState == index) {

                                    widget.isPressTypeCubit.setState(5);
                                    widget.searchData.estateTypeId = 5;
                                  } else {
                                    widget.isPressTypeCubit.setState(index);
                                    widget.searchData.estateTypeId = index + 1;
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: kSmallAllPadding,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: circularBorderRadius,
                                        border: Border.all(
                                            color: pressState == index
                                                ? AppColors.lightblue
                                                : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                      ),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(iconPath,
                                            color: AppColors.primaryColor),
                                      ),
                                      /*child: Image.asset(iconPath,
                                          color: AppColors.primaryColor),*/
                                    ),
                                    ResText(
                                      estateType.estateTypes![index].name.toString().split("|").first ==
                                          "House" ||
                                          estateType.estateTypes![index].name
                                              .toString()
                                              .split("|")
                                              .first ==
                                              "بيت"
                                          ? AppLocalizations.of(context)!.house
                                          : estateType.estateTypes![index].name
                                          .toString()
                                          .split("|")
                                          .first ==
                                          "Shop" ||
                                          estateType.estateTypes![index].name
                                              .toString()
                                              .split("|")
                                              .first ==
                                              "محل"
                                          ? AppLocalizations.of(context)!
                                          .shop
                                          : estateType.estateTypes![index].name
                                          .toString()
                                          .split("|")
                                          .first ==
                                          "Farm" ||
                                          estateType
                                              .estateTypes![index]
                                              .name
                                              .toString()
                                              .split("|")
                                              .first ==
                                              "مزرعة"
                                          ? AppLocalizations.of(context)!.farm
                                          : estateType.estateTypes![index].name.toString().split("|").first == "Land" || estateType.estateTypes![index].name.toString().split("|").first == "أرض"
                                          ? AppLocalizations.of(context)!.land
                                          : AppLocalizations.of(context)!.villa,
                                      textStyle: TextStyle(
                                          color: !isDark
                                              ? pressState == index
                                              ? AppColors.lightblue
                                              : isDark
                                              ? AppColors
                                              .lightGrey2Color
                                              : AppColors.primaryColor
                                              : pressState == index
                                              ? AppColors.lightblue
                                              : isDark
                                              ? AppColors
                                              .lightGrey2Color
                                              : AppColors.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );

                    /* return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.removeSelect &&
                                  pressState < 5 &&
                                  pressState == 0) {
                                print("PressState : ${pressState}");
                                widget.isPressTypeCubit.setState(5);
                                widget.searchData.estateTypeId = 5;
                              } else {
                                print("PressState else : ${pressState}");

                                widget.isPressTypeCubit.setState(0);
                                widget.searchData.estateTypeId = 1;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: kSmallAllPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: circularBorderRadius,
                                    border: Border.all(
                                        color: pressState == 0
                                            ? AppColors.lightblue
                                            : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                  ),
                                  child: Image.asset(buildIconPath,
                                      color: AppColors.primaryColor),
                                ),
                                ResText(
                                  AppLocalizations.of(context)!.house,
                                  textStyle: TextStyle(
                                      color: !isDark
                                          ? pressState == 0
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor
                                          : pressState == 0
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kWi16,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.removeSelect &&
                                  pressState < 5 &&
                                  pressState == 3) {
                                widget.isPressTypeCubit.setState(5);
                                widget.searchData.estateTypeId = 5;
                              } else {
                                widget.isPressTypeCubit.setState(3);
                                widget.searchData.estateTypeId = 4;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: kSmallAllPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: circularBorderRadius,
                                    border: Border.all(
                                        color: pressState == 3
                                            ? AppColors.lightblue
                                            : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                  ),
                                  child: Image.asset(farmIconPath,
                                      color: AppColors.primaryColor),
                                ),
                                ResText(
                                  AppLocalizations.of(context)!.farm,
                                  textStyle: TextStyle(
                                      color: !isDark
                                          ? pressState == 3
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor
                                          : pressState == 3
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kWi16,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.removeSelect &&
                                  pressState < 5 &&
                                  pressState == 2) {
                                widget.isPressTypeCubit.setState(5);
                                widget.searchData.estateTypeId = 5;
                              } else {
                                widget.isPressTypeCubit.setState(2);
                                widget.searchData.estateTypeId = 3;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: kTinyAllPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: circularBorderRadius,
                                    border: Border.all(
                                        color: pressState == 2
                                            ? AppColors.lightblue
                                            : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                  ),
                                  child: Image.asset(landIconPath,
                                      color: AppColors.primaryColor),
                                ),
                                ResText(
                                  AppLocalizations.of(context)!.land,
                                  textStyle: TextStyle(
                                      color: !isDark
                                          ? pressState == 2
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor
                                          : pressState == 2
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kWi16,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.removeSelect &&
                                  pressState < 5 &&
                                  pressState == 1) {
                                widget.isPressTypeCubit.setState(5);
                                widget.searchData.estateTypeId = 5;
                              } else {
                                widget.isPressTypeCubit.setState(1);
                                widget.searchData.estateTypeId = 2;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: kTinyAllPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: circularBorderRadius,
                                    border: Border.all(
                                        color: pressState == 1
                                            ? AppColors.lightblue
                                            : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                  ),
                                  child: Image.asset(shopIconPath,
                                      color: AppColors.primaryColor),
                                ),
                                ResText(
                                  AppLocalizations.of(context)!.shop,
                                  textStyle: TextStyle(
                                      color: !isDark
                                          ? pressState == 1
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor
                                          : pressState == 1
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kWi16,
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (widget.removeSelect &&
                                  pressState < 5 &&
                                  pressState == 4) {
                                widget.isPressTypeCubit.setState(5);
                                widget.searchData.estateTypeId = 5;
                              } else {
                                widget.isPressTypeCubit.setState(4);
                                widget.searchData.estateTypeId = 5;
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: kTinyAllPadding,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: circularBorderRadius,
                                    border: Border.all(
                                        color: pressState == 4
                                            ? AppColors.lightblue
                                            : isDark
                                                ? AppColors.lightGrey2Color
                                                : AppColors.primaryColor),
                                  ),
                                  child: Image.asset(villaIconPath,
                                      color: AppColors.primaryColor),
                                ),
                                ResText(
                                  AppLocalizations.of(context)!.villa,
                                  textStyle: TextStyle(
                                      color: !isDark
                                          ? pressState == 4
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor
                                          : pressState == 4
                                              ? AppColors.lightblue
                                              : isDark
                                                  ? AppColors.lightGrey2Color
                                                  : AppColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  */
                  }
                  return SizedBox();
                })
                :Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.removeSelect &&
                          pressState < 5 &&
                          pressState == 0) {
                        widget.isPressTypeCubit.setState(5);
                        widget.searchData.estateTypeId = 5;
                      } else {
                        widget.isPressTypeCubit.setState(0);
                        widget.searchData.estateTypeId = 1;
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: kSmallAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: circularBorderRadius,
                            border: Border.all(
                                color: pressState == 0
                                    ? AppColors.lightblue
                                    : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                          ),
                          child: Image.asset(buildIconPath,
                              color: AppColors.primaryColor),
                        ),
                        ResText(
                          AppLocalizations.of(context)!.house,
                          textStyle: TextStyle(
                              color: !isDark
                                  ? pressState == 0
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor
                                  : pressState == 0
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                kWi16,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.removeSelect &&
                          pressState < 5 &&
                          pressState == 3) {
                        widget.isPressTypeCubit.setState(5);
                        widget.searchData.estateTypeId = 5;
                      } else {
                        widget.isPressTypeCubit.setState(3);
                        widget.searchData.estateTypeId = 4;
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: kSmallAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: circularBorderRadius,
                            border: Border.all(
                                color: pressState == 3
                                    ? AppColors.lightblue
                                    : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                          ),
                          child: Image.asset(farmIconPath,
                              color: AppColors.primaryColor),
                        ),
                        ResText(
                          AppLocalizations.of(context)!.farm,
                          textStyle: TextStyle(
                              color: !isDark
                                  ? pressState == 3
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor
                                  : pressState == 3
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                kWi16,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.removeSelect &&
                          pressState < 5 &&
                          pressState == 2) {
                        widget.isPressTypeCubit.setState(5);
                        widget.searchData.estateTypeId = 5;
                      } else {
                        widget.isPressTypeCubit.setState(2);
                        widget.searchData.estateTypeId = 3;
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: kTinyAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: circularBorderRadius,
                            border: Border.all(
                                color: pressState == 2
                                    ? AppColors.lightblue
                                    : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                          ),
                          child: Image.asset(landIconPath,
                              color: AppColors.primaryColor),
                        ),
                        ResText(
                          AppLocalizations.of(context)!.land,
                          textStyle: TextStyle(
                              color: !isDark
                                  ? pressState == 2
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor
                                  : pressState == 2
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                kWi16,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.removeSelect &&
                          pressState < 5 &&
                          pressState == 1) {
                        widget.isPressTypeCubit.setState(5);
                        widget.searchData.estateTypeId = 5;
                      } else {
                        widget.isPressTypeCubit.setState(1);
                        widget.searchData.estateTypeId = 2;
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: kTinyAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: circularBorderRadius,
                            border: Border.all(
                                color: pressState == 1
                                    ? AppColors.lightblue
                                    : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                          ),
                          child: Image.asset(shopIconPath,
                              color: AppColors.primaryColor),
                        ),
                        ResText(
                          AppLocalizations.of(context)!.shop,
                          textStyle: TextStyle(
                              color: !isDark
                                  ? pressState == 1
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor
                                  : pressState == 1
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
                kWi16,
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.removeSelect &&
                          pressState < 5 &&
                          pressState == 4) {
                        widget.isPressTypeCubit.setState(5);
                        widget.searchData.estateTypeId = 5;
                      } else {
                        widget.isPressTypeCubit.setState(4);
                        widget.searchData.estateTypeId = 5;
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: kTinyAllPadding,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: circularBorderRadius,
                            border: Border.all(
                                color: pressState == 4
                                    ? AppColors.lightblue
                                    : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                          ),
                          child: Image.asset(villaIconPath,
                              color: AppColors.primaryColor),
                        ),
                        ResText(
                          AppLocalizations.of(context)!.villa,
                          textStyle: TextStyle(
                              color: !isDark
                                  ? pressState == 4
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor
                                  : pressState == 4
                                  ? AppColors.lightblue
                                  : isDark ? AppColors.lightGrey2Color : AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        kHe16,
      ],
    );
  }
}
