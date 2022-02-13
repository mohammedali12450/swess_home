import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class RowInformationChoices extends StatelessWidget {
  final List<String> choices;
  final void Function(int currentIndex) onSelect;

  final String content;

  RowInformationChoices(
      {Key? key, required this.choices, required this.content, required this.onSelect}) : super(key: key);

  final ChannelCubit choicesCubit = ChannelCubit(0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: choicesCubit,
          builder: (_, currentChoiceIndex) {
            onSelect(currentChoiceIndex);
            return InkWell(
              onTap: () {
                choicesCubit.setState((currentChoiceIndex == choices.length - 1)
                    ? 0
                    : currentChoiceIndex + 1);
              },
              child: Container(
                padding: kSmallSymWidth,
                width: Res.width(88),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: black),
                ),
                child: ResText(
                  choices.elementAt(currentChoiceIndex),
                  textStyle: textStyling(S.s16, W.w5, C.bl),
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
