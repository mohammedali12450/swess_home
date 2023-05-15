import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesReviewField extends StatelessWidget {
  const NotesReviewField({
    super.key,
    required this.formStateKey,
    required this.controller,
    required this.validator,
  });

  final GlobalKey<FormState> formStateKey;
  final TextEditingController controller;
  final String? Function(String? val) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Form(
        key: formStateKey,
        child: TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.writeNotes,
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
