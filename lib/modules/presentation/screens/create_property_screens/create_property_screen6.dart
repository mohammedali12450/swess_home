import 'package:flutter/material.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/create_property_template.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'create_property_screen_finish.dart';

class CreatePropertyScreen6 extends StatefulWidget {
  static const String id = "CreatePropertyScreen6";

  final Estate currentOffer;

  const CreatePropertyScreen6({Key? key, required this.currentOffer})
      : super(key: key);

  @override
  _CreatePropertyScreen6State createState() => _CreatePropertyScreen6State();
}

class _CreatePropertyScreen6State extends State<CreatePropertyScreen6> {
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CreatePropertyTemplate(
      headerIconPath: documentOutlineIconPath,
      headerText: "الخطوة السادسة",
      body: Column(
        children: [
          kHe24,
          SizedBox(
            width: inf,
            child: ResText(
              ":وصف العقار (اختياري)",
              textStyle: textStyling(S.s18, W.w6, C.bl),
              textAlign: TextAlign.right,
            ),
          ),
          kHe16,
          SizedBox(
            width: inf,
            height: Res.height(200),
            child: TextField(
              style: textStyling(S.s15, W.w5, C.bl),
              maxLines: 8,
              maxLength: 600,
              textDirection: TextDirection.rtl,
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: "أدخل وصف إضافي لعقارك !",
                hintStyle: textStyling(S.s15, W.w5, C.hint),
                hintTextDirection: TextDirection.rtl,
                border: kOutlinedBorderBlack,
                focusedBorder: kOutlinedBorderBlack,
              ),
            ),
          ),
          kHe36,
          MyButton(
            child: ResText(
              "إنشاء العرض العقاري",
              textStyle: textStyling(S.s16, W.w5, C.wh),
            ),
            width: Res.width(240),
            height: Res.height(56),
            color: AppColors.secondaryColor,
            onPressed: () {
              widget.currentOffer.description = descriptionController.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreatePropertyScreenFinish(
                      currentOffer: widget.currentOffer),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
