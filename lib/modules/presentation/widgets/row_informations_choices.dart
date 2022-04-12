import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';

import '../../data/providers/locale_provider.dart';

class RowInformationChoices extends StatelessWidget {
  final List<String> choices;
  final void Function(int currentIndex) onSelect;
  final bool hasSpacerBetween;


  final String content;

  RowInformationChoices({
    Key? key,
    required this.choices,
    required this.content,
    required this.onSelect,
    this.hasSpacerBetween = false,
  }) : super(key: key);

  final ChannelCubit choicesCubit = ChannelCubit(0);

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: isArabic ? 36.w : 0,
            right: !isArabic ? 36.w : 0,
          ),
          child: Text(
            content,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (hasSpacerBetween) const Spacer(),
        BlocBuilder<ChannelCubit, dynamic>(
          bloc: choicesCubit,
          builder: (_, currentChoiceIndex) {
            onSelect(currentChoiceIndex);
            return InkWell(
              onTap: () {
                choicesCubit.setState(
                    (currentChoiceIndex == choices.length - 1) ? 0 : currentChoiceIndex + 1);
              },
              child: Container(
                width: 108.w,
                padding: kSmallSymWidth,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Theme.of(context).colorScheme.onBackground),
                ),
                child: AutoSizeText(
                  choices.elementAt(currentChoiceIndex),
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
