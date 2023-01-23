import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';
import '../../data/providers/theme_provider.dart';

Widget buildChoiceContainer({
  required context,
  required ChannelCubit cubit,
  required String textLeft,
  required String textRight,
  required Function() onTapLeft,
  required Function() onTapRight,
  double? paddingVertical,
  double? paddingHorizontal,
}) {
  bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
  return BlocBuilder<ChannelCubit, dynamic>(
      bloc: cubit,
      builder: (_, isChoice) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: paddingVertical ?? 12,
              horizontal: paddingHorizontal ?? 12),
          child: Container(
            padding: const EdgeInsets.all(3),
            height: 37,
            decoration: BoxDecoration(
              border: Border.all(
                  color: !isDark ? Colors.black38 : AppColors.yellowDarkColor,
                  width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? isChoice
                                ? AppColors.lastColor.withOpacity(0.5)
                                : AppColors.white
                            : !isChoice
                                ? AppColors.lastColor.withOpacity(0.5)
                                : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        textRight,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: isDark
                                ? isChoice
                                    ? AppColors.white
                                    : AppColors.secondaryDark
                                : !isChoice
                                    ? AppColors.primaryColor
                                    : AppColors.secondaryDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      onTapRight();
                      cubit.setState(false);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? !isChoice
                                ? AppColors.lastColor.withOpacity(0.5)
                                : AppColors.white
                            : isChoice
                                ? AppColors.lastColor.withOpacity(0.5)
                                : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        textLeft,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: !isChoice
                                ? AppColors.primaryColor
                                : AppColors.secondaryDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      onTapLeft();
                      cubit.setState(true);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
