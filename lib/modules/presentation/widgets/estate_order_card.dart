import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_bloc.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/estate_order_repository.dart';

class EstateOrderCard extends StatefulWidget {
  final EstateOrder estateOrder;
  final Color color;
  final Function onTap;

  const EstateOrderCard(
      {Key? key,
      required this.estateOrder,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  _EstateOrderCardState createState() => _EstateOrderCardState();
}

class _EstateOrderCardState extends State<EstateOrderCard> {
  DeleteEstatesBloc deleteEstatesBloc =
      DeleteEstatesBloc(EstateOrderRepository());

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    String estateType =
        widget.estateOrder.estateType!.name.split("|").elementAt(1);
    String estateOfferType = widget.estateOrder.estateOfferType!.name;
    String estateHeader = AppLocalizations.of(context)!
        .estate_offer_sentence(estateType, estateOfferType);
    return Container(
        width: 1.sw,
        padding: const EdgeInsets.symmetric(
          vertical: kSmallPadding,
        ),
        margin: EdgeInsets.symmetric(
          // vertical: 5.h,
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
            width: 1,
            color: AppColors.white,
          ),
          borderRadius: lowBorderRadius,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.32),
                offset: const Offset(2, 2),
                blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              swessHomeIconPath,
              width: 62,
              height: 62,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 6.w,
            ),
            Expanded(
              child: Padding(
                padding: isArabic
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${AppLocalizations.of(context)!.estate_location}: ${widget.estateOrder.location!.getLocationName()}",
                        style: cairoTextStyle.copyWith(
                            color: isDark ? AppColors.white : Colors.black)),
                    kHe8,
                    Row(
                      children: [
                        Text(
                            "${AppLocalizations.of(context)!.order_type}: ${widget.estateOrder.estateOfferType!.name}",
                            style: cairoTextStyle.copyWith(
                                color:
                                    isDark ? AppColors.white : Colors.black)),
                        Spacer(),
                        Text(
                            "${AppLocalizations.of(context)!.estate_type}: ${widget.estateOrder.estateType!.name}",
                            style: cairoTextStyle.copyWith(
                                color: isDark ? AppColors.white : Colors.black))
                      ],
                    ),
                    kHe8,
                    Text(
                      "${AppLocalizations.of(context)!.price_domain}: ${AppLocalizations.of(context)!.between} "
                      "${widget.estateOrder.priceMin == "0" ? AppLocalizations.of(context)!.undefined : widget.estateOrder.priceMin}  , ${widget.estateOrder.priceMax == "999999999999999999" ? AppLocalizations.of(context)!.undefined : widget.estateOrder.priceMax} ${AppLocalizations.of(context)!.syrian_currency} ",
                      style: cairoTextStyle.copyWith(
                          color: isDark ? AppColors.white : Colors.black),
                    ),
                    kHe8,
                    Text(
                      "${widget.estateOrder.description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: cairoTextStyle.copyWith(
                        fontSize: 10,
                        color: isDark ? AppColors.white : Color(0xff5A5A5A),
                      ),
                    ),
                    kHe8,
                    buildEstateStatus(isDark),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget buildEstateStatus(bool isDark) {
    return Row(
      children: [
        Text(
          "${AppLocalizations.of(context)!.request_status} : ",
          style: cairoTextStyle.copyWith(
              color: isDark ? AppColors.white : Colors.black),
        ),
        Expanded(
          child: Text(
            " ${widget.estateOrder.orderStatus}",
            overflow: TextOverflow.ellipsis,
            style: cairoTextStyle.copyWith(
                color: widget.estateOrder.orderStatus ==
                        AppLocalizations.of(context)!.rejected
                    ? Color(0xffFF0000)
                    : widget.estateOrder.orderStatus ==
                            AppLocalizations.of(context)!.accepted
                        ? Color(0xff00720B)
                        : (isDark ? AppColors.white : Colors.black)),
          ),
        ),
        Column(
          children: [
            if (widget.estateOrder.orderStatus ==
                AppLocalizations.of(context)!.in_progress) ...[
              // DeleteRequestWidget(),
              DeleteRequestWidget(onTapYes: widget.onTap, isDark: isDark),
            ],
            if (widget.estateOrder.orderStatus ==
                AppLocalizations.of(context)!.rejected) ...[
              const RejectReasonsWidget(),
            ],
            if (widget.estateOrder.orderStatus ==
                AppLocalizations.of(context)!.accepted) ...[
              Text(
                widget.estateOrder.orderStatus!,
                style: cairoTextStyle.copyWith(color: Colors.green),
              ),
            ]
          ],
        )
      ],
    );
    /*return Text.rich(
      TextSpan(
          text: AppLocalizations.of(context)!.request_status,
          style: TextStyle(color: Colors.black, fontSize: 15.sp),
          children: [
            TextSpan(
                text: widget.estateOrder.orderStatus!,
                style: TextStyle(
                    color: (widget.estateOrder.orderStatus ==
                            AppLocalizations.of(context)!.pending)
                        ? AppColors.yellowDarkColor
                        : (widget.estateOrder.orderStatus ==
                                AppLocalizations.of(context)!.rejected)
                            ? Colors.red
                            : Colors.green))
          ]),
    );*/
  }
}

class DeleteRequestWidget extends StatelessWidget {
  final Function onTapYes;
  final bool isDark;
  const DeleteRequestWidget({
    super.key,
    required this.onTapYes,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showWonderfulAlertDialog(context, AppLocalizations.of(context)!.caution,
            AppLocalizations.of(context)!.confirm_delete,
            titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 20.sp),
            removeDefaultButton: true,
            dialogButtons: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                ElevatedButton(
                    child: Text(
                      AppLocalizations.of(context)!.yes,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      onTapYes();
                    }),
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.no,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ])
            ]);
      },
      child: Container(
        padding: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? Color(0xffff3835) : AppColors.red,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              trashPath,
              height: 20.r,
            ),
            SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.delete_request,
              style: cairoTextStyle.copyWith(
                  color: isDark ? Color(0xffff3835) : AppColors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class RejectReasonsWidget extends StatelessWidget {
  const RejectReasonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffC70000),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              receiptPath,
              color: Color(0xffC70000),
            ),
            SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.reject_reasons,
              style: cairoTextStyle.copyWith(
                fontSize: 12,
                color: Color(0xffC70000),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextStyle cairoTextStyle = GoogleFonts.cairo(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
