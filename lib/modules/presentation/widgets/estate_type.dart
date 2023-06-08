import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  const EstateTypeWidget(
      {required this.searchData,
      required this.isPressTypeCubit,
      required this.removeSelect,
      Key? key})
      : super(key: key);

  @override
  State<EstateTypeWidget> createState() => _EstateTypeWidgetState();
}

class _EstateTypeWidgetState extends State<EstateTypeWidget> {
  late bool isDark;

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
            return Row(
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
                                      : AppColors.primaryColor
                                  : pressState == 0
                                      ? AppColors.lightblue
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
                                      : AppColors.primaryColor
                                  : pressState == 3
                                      ? AppColors.lightblue
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
                                      : AppColors.primaryColor
                                  : pressState == 2
                                      ? AppColors.lightblue
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
                                      : AppColors.primaryColor
                                  : pressState == 1
                                      ? AppColors.lightblue
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
                                      : AppColors.primaryColor
                                  : pressState == 4
                                      ? AppColors.lightblue
                                      : AppColors.primaryColor),
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
