import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/modules/business_logic_components/cubits/channel_cubit.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RowInformationSwitcher extends StatefulWidget {
  final String content;

  final String switcherContent;

  final Function(bool isSelected) onSelected;

  final bool? initialState;

  const RowInformationSwitcher({
    Key? key,
    required this.content,
    required this.switcherContent,
    required this.onSelected,
    this.initialState = false,
  }) : super(key: key);

  @override
  State<RowInformationSwitcher> createState() => _RowInformationSwitcherState();
}

class _RowInformationSwitcherState extends State<RowInformationSwitcher> {
  late ChannelCubit pressButtonCubit;

  @override
  void initState() {
    super.initState();
    pressButtonCubit = ChannelCubit(widget.initialState);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            left: (isArabic) ? 18.w : 0,
            right: (isArabic) ? 0 : 18.w,
          ),
          child: Text(
            widget.content,
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: isDarkMode ? Colors.white70 : AppColors.primaryColor,
              background: Colors.white,
              onBackground: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: BlocBuilder<ChannelCubit, dynamic>(
            bloc: pressButtonCubit,
            builder: (context, isPressed) {
              return InkWell(
                onTap: () {
                  pressButtonCubit.setState(!pressButtonCubit.state);
                  widget.onSelected(!isPressed);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(color: Theme.of(context).colorScheme.onBackground),
                      color:
                      (isPressed) ? Theme.of(context).colorScheme.primary : Colors.transparent),
                  child: Text(
                    (isPressed)? widget.switcherContent : AppLocalizations.of(context)!.no,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: (isPressed)
                            ? (isDarkMode)
                            ? AppColors.black
                            : Theme.of(context).colorScheme.background
                            : Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
