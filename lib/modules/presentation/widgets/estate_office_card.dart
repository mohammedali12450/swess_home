import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/modules/data/models/estate_office.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

import 'res_text.dart';

class EstateOfficeCard extends StatelessWidget {
  final EstateOffice office;
  final Function() onTap ;

  const EstateOfficeCard({Key? key, required this.office , required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8),),
          color: AppColors.white,
        ),
        height: Res.height(120),
        margin: EdgeInsets.symmetric( horizontal: Res.width(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Hero(
                tag : office.id.toString() ,
                child: CachedNetworkImage(
                  imageUrl: baseUrl + office.logo!,
                ),
              ),
            ) ,
            Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResText(
                    office.name! ,
                    textStyle: textStyling(S.s20, W.w5, C.bl),
                  ) ,
                  kHe12 ,
                  ResText(
                    office.location!.getLocationName() ,
                    textStyle: textStyling(S.s16, W.w5, C.bl),
                  ) ,
                ],

              )
            )
          ],
        ),
      ),
    );
  }
}
