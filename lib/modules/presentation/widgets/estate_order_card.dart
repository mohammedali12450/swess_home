import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/candidates_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
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
        horizontal: kSmallPadding,
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
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.32),
              offset: const Offset(2, 2),
              blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            // color: AppColors.hintColor,
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            width: 1.sw,
            child: InkWell(
              onTap: () {
                showWonderfulAlertDialog(
                    context,
                    AppLocalizations.of(context)!.caution,
                    AppLocalizations.of(context)!.confirm_delete,
                    titleTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 20.sp),
                    removeDefaultButton: true,
                    dialogButtons: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                child: Text(
                                  AppLocalizations.of(context)!.yes,
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await widget.onTap();
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
              child: Icon(
                Icons.close,
                color: isDark ? AppColors.white : AppColors.hintColor,
              ),
            ),
          ),
          kHe8,
          Row(
            children: <Widget>[
              Text(estateHeader, style: Theme.of(context).textTheme.headline5),
              const Spacer(),
              Text(
                  DateHelper.getDateByFormat(
                    DateTime.parse(widget.estateOrder.createdAt!),
                    "yyyy/MM/dd",
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Theme.of(context).hintColor)),
            ],
          ),
          kHe8,
          Text(widget.estateOrder.location!.getLocationName(),
              style: Theme.of(context).textTheme.subtitle1),
          if (widget.estateOrder.priceDomain != null) ...[
            12.verticalSpace,
            Text("${AppLocalizations.of(context)!.price_domain} : ",
                style: Theme.of(context).textTheme.subtitle1),
          ],
          kHe8,
          Text(
            "${AppLocalizations.of(context)!.notes} : ${widget.estateOrder.description}",
            maxLines: 50,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.5),
          ),
          kHe16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildEstateStatus(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  //splashFactory: NoSplash.splashFactory,
                  maximumSize: Size(138.w,50.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                  backgroundColor: isDark
                      ? AppColors.lightblue
                      : AppColors.red,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(delete_order,width: 25,),
                    Text(
                      AppLocalizations.of(context)!.delete_order,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColors.white, height: 1.4.h),
                    ),
                  ],
                ),
                onPressed: () {
                  showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.caution,
                      AppLocalizations.of(context)!.confirm_delete,
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20.sp),
                      removeDefaultButton: true,
                      dialogButtons: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.yes,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await widget.onTap();
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
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CandidatesScreen(
                          estates: widget.estateOrder.candidatesEstates ?? []),
                    ),
                  );*/

                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEstateStatus() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        TextSpan(
          text: "حالة الطلب : ",
            style: TextStyle(
                color: Colors.black , fontSize: 16.sp),
          children: [
               TextSpan(text: widget.estateOrder.orderStatus! ,
                 style: TextStyle(
                     color: (widget.estateOrder.orderStatus ==
                         AppLocalizations.of(context)!.pending)
                         ? AppColors.yellowDarkColor
                         : (widget.estateOrder.orderStatus ==
                         AppLocalizations.of(context)!.rejected)
                         ? Colors.red
                         : Colors.green))
          ]
        ),


      ),
    );
  }
}
