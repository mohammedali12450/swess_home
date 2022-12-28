import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/colors.dart';
import '../../business_logic_components/cubits/channel_cubit.dart';

Widget buildChoiceContainer({
  required context,
  required ChannelCubit cubit,
  required String textRight,
  required String textLeft,
  required Function() onTapRight,
  required Function() onTapLeft,
  double? paddingVertical,
  double? paddingHorizontal,
}) {
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
              border: Border.all(color: Colors.black38, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: !isChoice
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
                      cubit.setState(false);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isChoice
                            ? AppColors.lastColor.withOpacity(0.5)
                            : AppColors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        textRight,
                        style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: isChoice
                                ? AppColors.primaryColor
                                : AppColors.secondaryDark,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      onTapRight();
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
