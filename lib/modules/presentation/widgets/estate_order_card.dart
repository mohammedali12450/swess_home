import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/models/estate_order.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/candidates_screen.dart';
import 'package:swesshome/utils/helpers/date_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_bloc.dart';
import '../../business_logic_components/bloc/delete_recent_estate_order_bloc/delete_recent_estate_order_event.dart';
import '../../business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import '../../data/providers/locale_provider.dart';
import '../../data/repositories/estate_order_repository.dart';

class EstateOrderCard extends StatefulWidget {
  final EstateOrder estateOrder;

  const EstateOrderCard({Key? key, required this.estateOrder})
      : super(key: key);

  @override
  _EstateOrderCardState createState() => _EstateOrderCardState();
}

class _EstateOrderCardState extends State<EstateOrderCard> {
  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode(context);
    String estateType = widget.estateOrder.estateType!
        .getName(isArabic)
        .split("|")
        .elementAt(1);
    String estateOfferType =
        widget.estateOrder.estateOfferType!.getName(isArabic);
    String estateHeader = AppLocalizations.of(context)!
        .estate_offer_sentence(estateType, estateOfferType);

    return Container(
      width: 1.sw,
      padding: const EdgeInsets.symmetric(
        vertical: kMediumPadding,
        horizontal: kSmallPadding,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 8.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
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
                DeleteEstatesBloc deleteEstatesBloc =
                    DeleteEstatesBloc(EstateOrderRepository());
                deleteEstatesBloc.add(DeleteEstatesFetchStarted(
                    token: BlocProvider.of<UserLoginBloc>(context).user!.token!,
                    orderId: widget.estateOrder.id!));
              },
              child: Icon(
                Icons.close,
                color: AppColors.hintColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
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
          kHe16,
          Text(widget.estateOrder.location!.getLocationName(),
              style: Theme.of(context).textTheme.subtitle1),
          if (widget.estateOrder.priceDomain != null) ...[
            12.verticalSpace,
            Text(
                AppLocalizations.of(context)!.price_domain +
                    " : " +
                    widget.estateOrder.priceDomain!
                        .getTextPriceDomain(isArabic),
                style: Theme.of(context).textTheme.subtitle1),
          ],
          if (widget.estateOrder.description != null) ...[
            8.verticalSpace,
            Text(
              AppLocalizations.of(context)!.notes +
                  " : " +
                  widget.estateOrder.description!,
              maxLines: 50,
              style:
                  Theme.of(context).textTheme.subtitle2!.copyWith(height: 1.8),
            ),
          ],
          kHe24,
          Container(
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            width: 1.sw,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                primary: (isDark)
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
              ),
              child: Text(
                AppLocalizations.of(context)!.view_candidates,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: AppColors.black, height: 1.4),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CandidatesScreen(
                        estates: widget.estateOrder.candidatesEstates ?? []),
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
