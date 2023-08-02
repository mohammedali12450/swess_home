import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../data/providers/locale_provider.dart';
// import '../../data/providers/theme_provider.dart';

Future<void> myDatePicker(
  BuildContext context, {
  DateTime? minTime,
  DateTime? maxTime,
  DateTime? currentTime,
  Function(DateTime dateTime)? onConfirm,
  Function(DateTime dateTime)? onChanged,
  Function()? onCancel,
  TextEditingController? editingController,
  showTitleActions = true,
}) async {
  bool isArabic =
      Provider.of<LocaleProvider>(context, listen: false).isArabic();
  //bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);

  await DatePicker.showDatePicker(
    context,
    showTitleActions: true,
    minTime: minTime,
    maxTime: maxTime,
    theme: DatePickerTheme(
      headerColor: AppColors.primaryColor,
      backgroundColor: AppColors.secondaryColor,
      itemStyle: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.sp),
      cancelStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
      doneStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
    ),
    onConfirm: (date) {
      if (onConfirm != null) {
        var inputDate = DateFormat('dd/MM/yyyy').format(date);
        editingController!.text = inputDate;
        onConfirm(date);
        return;
      }
    },
    onChanged: (date) {
      if (onChanged != null) {
        onChanged(date);
        return;
      }
    },
    onCancel: () {
      if (onCancel != null) {
        onCancel();
        return;
      }
    },
    currentTime: currentTime,
    locale: isArabic ? LocaleType.ar : LocaleType.en,
  );
}
