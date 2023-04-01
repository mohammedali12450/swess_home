import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'navigation_bar_screen.dart';
import 'my_estates_orders_screen.dart';

class AfterEstateOrderScreen extends StatefulWidget {
  static const String id = "AfterEstateOrderScreen";

  const AfterEstateOrderScreen({Key? key}) : super(key: key);

  @override
  _AfterEstateOrderScreenState createState() => _AfterEstateOrderScreenState();
}

class _AfterEstateOrderScreenState extends State<AfterEstateOrderScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = Provider.of<LocaleProvider>(context).isArabic();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.create_estate_order,
            ),
            actions: [
              Container(
                margin: EdgeInsets.only(
                  left: (isArabic) ? 16.w : 0,
                  right: (!isArabic) ? 16.w : 0,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.history,
                    color: AppColors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RecentEstateOrdersScreen.id);
                  },
                ),
              )
            ]),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: SvgPicture.asset(checkOutlineIconPath,
                    color: Theme.of(context).colorScheme.primary),
              ),
              kHe32,
              Text(
                AppLocalizations.of(context)!.estate_order_sent,
                style: Theme.of(context).textTheme.headline4,
                textAlign: TextAlign.center,
                maxLines: 50,
              ),
              kHe24,
              Text(
                AppLocalizations.of(context)!.after_order_body,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(height: 1.8),
                textAlign: TextAlign.center,
                maxLines: 50,
              ),
              kHe40,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(200, 64),
                ),
                child: Text(
                  AppLocalizations.of(context)!.ok,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NavigationBarScreen()),
                    ModalRoute.withName('/'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
