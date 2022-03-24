import 'package:flutter/material.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/presentation/screens/candidates_screen.dart';
import 'package:swesshome/modules/presentation/screens/recent_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'my_button.dart';

class EstateOrderCard extends StatefulWidget {
  final EstateOrder estateOrder;

  const EstateOrderCard({Key? key, required this.estateOrder}) : super(key: key);

  @override
  _EstateOrderCardState createState() => _EstateOrderCardState();
}

class _EstateOrderCardState extends State<EstateOrderCard> {
  @override
  Widget build(BuildContext context) {
    String estateType = widget.estateOrder.estateType!.getName(true).split("|").elementAt(1);
    String estateOfferType = widget.estateOrder.estateOfferType!.getName(true);
    String estateHeader = " مطلوب $estateType لل$estateOfferType";

    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(
        vertical: kMediumPadding,
        horizontal: kSmallPadding,
      ),
      margin: EdgeInsets.symmetric(
        vertical: Res.height(6),
        horizontal: Res.width(8),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.32), offset: const Offset(2, 2), blurRadius: 4),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ResText(
                DateHelper.getDateByFormat(
                  DateTime.parse(widget.estateOrder.createdAt!),
                  "yyyy/MM/dd",
                ),
                textStyle: textStyling(S.s15, W.w4, C.hint, fontFamily: F.roboto),
              ),
              const Spacer(),
              ResText(
                estateHeader,
                textStyle: textStyling(S.s17, W.w6, C.bl).copyWith(height: 1.8),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          kHe12,
          SizedBox(
            width: screenWidth,
            child: ResText(
              widget.estateOrder.location!.getLocationName(),
              textStyle: textStyling(S.s18, W.w4, C.bl).copyWith(height: 1.8),
              textAlign: TextAlign.right,
            ),
          ),
          if (widget.estateOrder.priceDomain != null) ...[
            kHe8,
            SizedBox(
              width: screenWidth,
              child: ResText(
                "السعر المطلوب: " + widget.estateOrder.priceDomain!.getTextPriceDomain(true),
                textStyle: textStyling(S.s16, W.w4, C.bl).copyWith(height: 1.8),
                textAlign: TextAlign.right,
              ),
            ),
          ],
          if (widget.estateOrder.description != null)
            SizedBox(
              width: screenWidth,
              child: ResText(
                "ملاحظات: " + widget.estateOrder.description!,
                maxLines: 50,
                textStyle: textStyling(S.s14, W.w5, C.bl).copyWith(height: 1.8),
                textAlign: TextAlign.right,
              ),
            ),
          kHe24,
          Container(
            alignment: Alignment.centerLeft,
            width: screenWidth,
            child: MyButton(
              child: ResText(
                "عرض الترشيحات",
                textStyle: textStyling(S.s15, W.w5, C.bl),
              ),
              shadow: [
                BoxShadow(
                    color: AppColors.black.withOpacity(0.32), offset: const Offset(-1, 1), blurRadius: 2)
              ],
              color: AppColors.baseColor,
              width: Res.width(180),
              height: Res.height(54),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CandidatesScreen(estates: widget.estateOrder.candidatesEstates ?? []),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
