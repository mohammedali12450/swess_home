import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/data/models/estate.dart';
import 'package:swesshome/modules/presentation/widgets/estate_card.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class CandidatesScreen extends StatefulWidget {
  static const String id = "CandidatesScreen";

  final List<Estate>? estates;

  const CandidatesScreen({Key? key, required this.estates}) : super(key: key);

  @override
  _CandidatesScreenState createState() => _CandidatesScreenState();
}

class _CandidatesScreenState extends State<CandidatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: Res.height(75),
        backgroundColor: AppColors.secondaryColor,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.only(
              right: Res.width(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ),
        ],
        title: SizedBox(
          width: inf,
          child: ResText(
            "العقارات المرشحة",
            textStyle: textStyling(S.s18, W.w5, C.wh),
            textAlign: TextAlign.right,
          ),
        ),
      ),
      body: Container(
        padding: kMediumSymWidth,
        child: (widget.estates == null || widget.estates!.isEmpty)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: screenWidth / 2,
                      color: AppColors.secondaryColor.withOpacity(0.64),
                    ),
                    kHe24,
                    ResText (
                      "! لا يوجد ترشيحات لهذا الطلب",
                      textStyle: textStyling(S.s18, W.w5, C.bl).copyWith(
                        color: AppColors.black.withOpacity(0.48),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.estates!.length,
                itemBuilder: (_, index) {
                  return EstateCard(estate: widget.estates!.elementAt(index));
                },
              ),
      ),
    );
  }
}
