import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../business_logic_components/bloc/estate_types_by_location/estate_types_by_location_bloc.dart';
import '../../business_logic_components/bloc/estate_types_by_location/estate_types_by_location_event.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/providers/theme_provider.dart';

Widget buildChoiceContainer({
  required context,
  required ChannelCubit cubit,
  required String textLeft,
  required String textRight,
  required Function() onTapLeft,
  required Function() onTapRight,
  EstateTypesByLocationBloc? estateTypesByLocationBloc,
  double? paddingVertical,
  double? paddingHorizontal,
}) {
  bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
  return BlocBuilder<ChannelCubit, dynamic>(
      bloc: cubit,
      builder: (_, isChoice) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 12.h,
              horizontal: paddingHorizontal ?? 12.w),
          child: Container(
            padding: const EdgeInsets.all(3),
            height: 45.h,
            decoration: BoxDecoration(
              border: Border.all(
                  color: isDark ? AppColors.lightGrey2Color : Colors.black38,
                  width: 1),
              borderRadius: lowBorderRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? isChoice
                                ? AppColors.white
                                : AppColors.lightblue
                            : !isChoice
                                ? AppColors.primaryColor
                                : AppColors.white,
                        borderRadius: lowBorderRadius,
                      ),
                      alignment: Alignment.center,
                      child: ResText(
                        textRight,
                        textStyle:
                            Theme.of(context).textTheme.headline5!.copyWith(
                                color: isDark
                                    ? isChoice
                                        ? AppColors.secondaryDark
                                        : AppColors.white
                                    : !isChoice
                                        ? AppColors.white
                                        : AppColors.secondaryDark,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      onTapRight();
                      cubit.setState(false);
                      if(estateTypesByLocationBloc!=null) {
                        estateTypesByLocationBloc.add(EstateTypeReset());
                      }
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? !isChoice
                                ? AppColors.white
                                : AppColors.lightblue
                            : isChoice
                                ? AppColors.primaryColor
                                : AppColors.white,
                        borderRadius: lowBorderRadius,
                      ),
                      alignment: Alignment.center,
                      child: ResText(
                        textLeft,
                        textStyle:
                            Theme.of(context).textTheme.headline5!.copyWith(
                                color: isDark
                                    ? !isChoice
                                        ? AppColors.secondaryDark
                                        : AppColors.white
                                    : isChoice
                                        ? AppColors.white
                                        : AppColors.secondaryDark,
                                fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      onTapLeft();
                      cubit.setState(true);
                      if(estateTypesByLocationBloc!=null) {
                       estateTypesByLocationBloc.add(EstateTypeReset());
                      }

                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
