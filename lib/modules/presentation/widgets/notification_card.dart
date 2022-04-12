import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';


class NotificationCard extends StatelessWidget {
  final String title;

  final String body;

  final String date;

  final bool isNew;

  final Function() onTap;

  final double topPadding;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.body,
    required this.date,
    required this.isNew,
    required this.onTap,
    this.topPadding = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
            margin: EdgeInsets.only(bottom: 3, top: topPadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.18),
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                16.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(
                    left: (isArabic) ? 12.w : 0,
                    right: (!isArabic) ? 12.w : 0,
                  ),
                  child: Text(
                    body,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 10,
                  ),
                ),
                8.verticalSpace,
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.64),
                  ),
                  textAlign: TextAlign.end,
                ),
                12.verticalSpace,
              ],
            ),
          ),
          if (isNew)
            Positioned(
              left: (isArabic) ? 16.w : null,
              right: (!isArabic) ? 16.w : null,
              top: 12.h,
              child: Container(
                height: 32.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.new_notification,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Theme.of(context).colorScheme.background),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
