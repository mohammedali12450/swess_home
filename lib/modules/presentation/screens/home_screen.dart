import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/constants/application_constants.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/fcm_bloc/fcm_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/models/search_data.dart';
import 'package:swesshome/modules/data/providers/locale_provider.dart';
import 'package:swesshome/modules/data/providers/theme_provider.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_screen.dart';
import 'package:swesshome/modules/presentation/widgets/app_drawer.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'office_search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "HomeScreen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserLoginBloc _userAuthenticationBloc;
  late bool isArabic;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApplicationSharedPreferences.setWalkThroughPassState(true);
    _userAuthenticationBloc = BlocProvider.of<UserLoginBloc>(context);
    if (_userAuthenticationBloc.user != null) {
      sendFcmToken(0);
    }
  }

  Future sendFcmToken(int attempt) async {
    if (attempt == 5) return;
    if (firebaseToken == null) {
      await Future.delayed(const Duration(seconds: 3));
      sendFcmToken(attempt + 1);
    }
    BlocProvider.of<FcmBloc>(context).add(
      SendFcmTokenProcessStarted(
          userToken: _userAuthenticationBloc.user!.token!),
    );
  }

  @override
  Widget build(BuildContext context) {
    isArabic = Provider.of<LocaleProvider>(context).isArabic();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.application_name,
          ),
          leading: Builder(
            builder: (context) {
              return Container(
                margin: EdgeInsets.only(
                  right: isArabic ? 8.w : 0,
                  left: !isArabic ? 8.w : 0,
                ),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              );
            },
          ),
          // actions: [
          //   BlocBuilder<NotificationsCubit, int>(
          //       builder: (_, notificationsCount) {
          //     return IconBadge(
          //       icon: const Icon(
          //         Icons.notifications_outlined,
          //       ),
          //       itemCount: notificationsCount,
          //       right: 0,
          //       top: 5.h,
          //       onTap: () async {
          //         if (BlocProvider.of<UserLoginBloc>(context).user == null) {
          //           await showWonderfulAlertDialog(
          //               context,
          //               AppLocalizations.of(context)!.confirmation,
          //               AppLocalizations.of(context)!
          //                   .this_features_require_login,
          //               removeDefaultButton: true,
          //               dialogButtons: [
          //                 ElevatedButton(
          //                   child: Text(
          //                     AppLocalizations.of(context)!.sign_in,
          //                   ),
          //                   onPressed: () async {
          //                     await Navigator.pushNamed(
          //                         context, AuthenticationScreen.id);
          //                     Navigator.pop(context);
          //                   },
          //                 ),
          //                 ElevatedButton(
          //                   child: Text(
          //                     AppLocalizations.of(context)!.cancel,
          //                   ),
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                 ),
          //               ],
          //               width: 400.w);
          //           return;
          //         }
          //         Navigator.pushNamed(context, NotificationScreen.id);
          //       },
          //       hideZero: true,
          //     );
          //   })
          // ],
        ),
        drawer: const Drawer(
          child: MyDrawer(),
        ),
        body: Container(
          padding: kSmallSymWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHomeScreenHeader(),
                kHe24,
                buildSearchCard(),
                kHe16,
                if (BlocProvider.of<SystemVariablesBloc>(context)
                    .systemVariables!
                    .isVacationsAvailable) ...[
                  buildVacationCard(),
                  kHe20,
                ],
                buildEstatePostingCard(),
                kHe12,
                buildEstateOrderCard(),
                kHe20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildEstatePostingCard() {
    return Container(
      width: inf,
      padding: kMediumAllPadding,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.search_for_estate_agent,
            style: Theme.of(context).textTheme.headline5,
          ),
          kHe12,
          Text(
            AppLocalizations.of(context)!.search_agent_card_body,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          kHe16,
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OfficeSearchScreen()),
              );
            },
            child: Container(
              width: inf,
              height: 64.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.56),
                ),
              ),
              child: Row(
                children: [
                  kWi12,
                  Transform.rotate(
                    angle: isArabic ? 1.5 : 0,
                    child: Icon(
                      Icons.search,
                      size: 24.w,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  kWi12,
                  Text(AppLocalizations.of(context)!.search_for_estate_agent,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack buildVacationCard() {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!
                    .this_feature_will_be_activated_soon);
          },
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  (!isDarkMode) ? AppColors.lastColor : Colors.white,
                  (!isDarkMode)
                      ? AppColors.lastColor.withOpacity(0.75)
                      : const Color(0xff90B8F8),
                ],
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              image: const DecorationImage(
                  image: AssetImage(beachImagePath),
                  fit: BoxFit.cover,
                  opacity: 0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: isArabic ? 1.5 : 0,
                  child: Icon(
                    Icons.search,
                    size: 28.w,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
                kHe12,
                Text(
                  AppLocalizations.of(context)!.vacations_and_farms,
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.background),
                ),
                kHe12,
                Padding(
                  padding: EdgeInsets.only(
                    left: isArabic ? 24.w : 0,
                    right: !isArabic ? 24.w : 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.vacations_card_body,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.background),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.only(
                  left: isArabic ? 16.w : 0, right: !isArabic ? 16.w : 0),
              child: Icon(
                (isArabic) ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        )
      ],
    );
  }

  Column buildHomeScreenHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kHe8,
        Text(
          AppLocalizations.of(context)!.welcome_in_swesshome,
          style: Theme.of(context).textTheme.headline6,
        ),
        kHe16,
        Text(
          AppLocalizations.of(context)!.home_screen_header,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.w400, fontSize: 16.sp),
        ),
      ],
    );
  }

  Container buildSearchCard() {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode(context);

    return Container(
      width: 1.sw,
      padding: kLargeSymHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            (isDarkMode)
                ? const Color(0xff90B8F8)
                : Theme.of(context).colorScheme.primary,
            (isDarkMode)
                ? AppColors.white.withOpacity(0.75)
                : Theme.of(context).colorScheme.primary.withOpacity(0.75)
          ],
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        image: const DecorationImage(
            image: AssetImage(flatImagePath), fit: BoxFit.cover, opacity: 0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Transform.rotate(
                angle: isArabic ? 1.5 : 0,
                child: Icon(
                  Icons.search,
                  size: 28.w,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              kWi16,
              Text(
                AppLocalizations.of(context)!.estate_offers,
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.background,
                    ),
              ),
            ],
          ),
          14.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              AppLocalizations.of(context)!.search_card_body,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            ),
          ),
          kHe32,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(150.w, 56.h),
                    minimumSize: Size(125.w, 56.h),
                    primary: Theme.of(context).colorScheme.background),
                child: Text(
                  AppLocalizations.of(context)!.sell,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(
                        searchData:
                            SearchData(estateOfferTypeId: sellOfferTypeNumber),
                      ),
                    ),
                  );
                },
              ),
              kWi16,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    maximumSize: Size(150.w, 56.h),
                    minimumSize: Size(125.w, 56.h),
                    primary: Theme.of(context).colorScheme.background),
                child: Text(
                  AppLocalizations.of(context)!.rent,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchScreen(
                        searchData:
                            SearchData(estateOfferTypeId: rentOfferTypeNumber),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildEstateOrderCard() {
    return Container(
      width: inf,
      padding: kSmallSymWidth,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
            color: Theme.of(context).colorScheme.onBackground, width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          kHe12,
          Text(
            AppLocalizations.of(context)!.estate_orders,
            style: Theme.of(context).textTheme.headline5,
          ),
          kHe12,
          Text(
            AppLocalizations.of(context)!.estate_order_card_body,
            style: Theme.of(context).textTheme.subtitle2,
            maxLines: 2,
          ),
          kHe16,
          Container(
            width: inf,
            alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(220.w, 56.h), padding: EdgeInsets.zero),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  kWi12,
                  Text(
                    AppLocalizations.of(context)!.create_estate_order,
                  ),
                  kWi12,
                ],
              ),
              onPressed: () async {
                if (BlocProvider.of<UserLoginBloc>(context).user == null) {
                  await showWonderfulAlertDialog(
                      context,
                      AppLocalizations.of(context)!.confirmation,
                      AppLocalizations.of(context)!.this_features_require_login,
                      removeDefaultButton: true,
                      dialogButtons: [
                        ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.sign_in,
                          ),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context, AuthenticationScreen.id);
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: Text(
                            AppLocalizations.of(context)!.cancel,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                      width: 400.w);
                  return;
                }
                Navigator.pushNamed(context, CreateOrderScreen.id);
              },
            ),
          )
        ],
      ),
    );
  }
}
