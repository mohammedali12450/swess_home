import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/modules/presentation/widgets/res_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/colors.dart';
import '../../../constants/design_constants.dart';
import '../../../utils/helpers/numbers_helper.dart';
import '../../data/models/rent_estate.dart';
import '../../data/providers/theme_provider.dart';

class ImmediatelyCard extends StatefulWidget {
  final RentEstate rentEstate;
  final bool isForCommunicate;

  const ImmediatelyCard(
      {required this.rentEstate, required this.isForCommunicate, Key? key})
      : super(key: key);

  @override
  State<ImmediatelyCard> createState() => _ImmediatelyCardState();
}

class _ImmediatelyCardState extends State<ImmediatelyCard> {
  late bool isDark;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    return Padding(
      padding: kTinyAllPadding,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: kTinyAllPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ResText(
                    widget.rentEstate.publishedAt,
                    textStyle: Theme.of(context).textTheme.headline6!.copyWith(
                        color: isDark
                            ? AppColors.yellowDarkColor
                            : AppColors.lastColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              buildType(AppLocalizations.of(context)!.address,
                  widget.rentEstate.location),
              Row(
                children: [
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.estate_type,
                        widget.rentEstate.estateType.split("|").first),
                  ),
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.rental_term,
                        widget.rentEstate.periodType.split("|").first),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildType(
                        AppLocalizations.of(context)!.estate_space,
                        widget.rentEstate.space.toString() +
                            " " +
                            AppLocalizations.of(context)!.meter),
                  ),
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.floor,
                        widget.rentEstate.floor.toString()),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.room,
                        widget.rentEstate.room.toString()),
                  ),
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.salon,
                        widget.rentEstate.room.toString()),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildType(AppLocalizations.of(context)!.bathroom,
                        widget.rentEstate.bathroom.toString()),
                  ),
                  Expanded(
                    child: buildType(
                        AppLocalizations.of(context)!.furnished,
                        widget.rentEstate.isFurnished
                            ? AppLocalizations.of(context)!.yes
                            : AppLocalizations.of(context)!.no),
                  ),
                ],
              ),
              buildType(AppLocalizations.of(context)!.interior_status,
                  widget.rentEstate.interiorStatuses),
              buildType(
                  AppLocalizations.of(context)!.estate_price,
                  NumbersHelper.getMoneyFormat(widget.rentEstate.price) +
                      " " +
                      AppLocalizations.of(context)!.syrian_bound),
              if (widget.isForCommunicate) ...[
                const Divider(),
                SizedBox(
                  height: 40.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (widget.rentEstate.whatsAppNumber != null) {
                            openWhatsApp(widget.rentEstate.whatsAppNumber);
                          } else {
                            openWhatsApp(widget.rentEstate.phoneNumber);
                          }
                        },
                        icon: const Icon(
                          Icons.whatsapp_outlined,
                          color: Colors.green,
                        ),
                      ),
                      const VerticalDivider(
                        thickness: 1,
                        width: 1,
                        color: AppColors.black,
                      ),
                      IconButton(
                        onPressed: () async {
                          launch(
                            "tel://" + widget.rentEstate.phoneNumber,
                          );
                        },
                        icon: const Icon(
                          Icons.call_outlined,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildType(String label, String text) {
    return Row(
      children: [
        ResText(
          label + " : ",
          textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 17.sp,
              color: isDark ? AppColors.primaryDark : AppColors.primaryColor),
        ),
        ResText(
          " " + text,
          textStyle: Theme.of(context).textTheme.headline6!.copyWith(
              fontSize: 17.sp,
              color: isDark ? AppColors.white : AppColors.black),
        ),
      ],
    );
  }

  openWhatsApp(whatsapp) async {
    var whatsappURlAndroid = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.whats_app_not_installed)));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text(AppLocalizations.of(context)!.whats_app_not_installed)));
      }
    }
  }
}
