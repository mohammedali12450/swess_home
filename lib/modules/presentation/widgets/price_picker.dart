import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/colors.dart';
import '../../../core/functions/screen_informations.dart';

openPricePicker(context, isDark,
    {required List<Text> items,
    required String title,
    required Function(dynamic) onSubmit}) {
  BottomPicker(
    backgroundColor: isDark ? AppColors.primaryColor : Colors.white,
    height: getScreenHeight(context) / 3,
    items: items,
    title: title,
    pickerTextStyle: TextStyle(
      color: !isDark ? Colors.black : Colors.white,
      fontWeight: FontWeight.bold,
    ),
    dismissable: true,
    iconClose: AppLocalizations.of(context)!.done,
    closeIconColor: !isDark ? AppColors.primaryColor : Colors.white,
    buttonAlignement: MainAxisAlignment.center,
    buttonSingleColor: AppColors.primaryColor,
    displaySubmitButton: false,
    titleStyle: TextStyle(
      color: !isDark ? Colors.black : Colors.white,
      fontWeight: FontWeight.bold,
    ),
    onClose: (data) {
      onSubmit(data);
    },
  ).show(context);
}
