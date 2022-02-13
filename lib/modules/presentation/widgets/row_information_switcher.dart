import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class RowInformationSwitcher extends StatelessWidget {
  final String content;

  final String switcherContent;

  final Function(bool isSelected) onSelected;

  final ChannelCubit pressButtonCubit = ChannelCubit(false);

  RowInformationSwitcher({
    Key? key,
    required this.content,
    required this.switcherContent,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: pressButtonCubit,
          builder: (_, isPressed) {
            return InkWell(
              onTap: () {
                pressButtonCubit.setState(!pressButtonCubit.state);
                onSelected(!isPressed);
              },
              child: Container(
                padding: kSmallSymWidth,
                width: Res.width(88),
                decoration: BoxDecoration(
                  color: (isPressed) ? secondaryColor : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(
                      color: (isPressed) ? Colors.transparent : black),
                ),
                child: ResText(
                  switcherContent,
                  textStyle:
                  textStyling(S.s16, W.w5, (isPressed) ? C.wh : C.bl),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        Container(
          padding: EdgeInsets.only(left: Res.width(36)),
          child: ResText(
            content,
            textStyle: textStyling(S.s18, W.w6, C.bl),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
