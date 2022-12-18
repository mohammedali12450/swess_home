import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/user_shared_preferences.dart';
import 'package:swesshome/core/walk_through/introduction_screen1.dart';
import 'package:swesshome/core/walk_through/introduction_screen2.dart';
import 'package:swesshome/core/walk_through/introduction_screen3.dart';
import 'package:swesshome/core/walk_through/introduction_screen4.dart';
import 'package:swesshome/modules/business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/area_units_bloc/area_units_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/area_units_bloc/area_units_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/location_bloc/locations_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/period_types_bloc/period_types_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/regions_bloc/regions_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/area_units_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/area_units_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/created_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/edit_profile_screen.dart';
import 'package:swesshome/modules/presentation/screens/faq_screen.dart';
import 'package:swesshome/modules/presentation/screens/languages_screen.dart';
import 'package:swesshome/modules/presentation/screens/notifications_screen.dart';
import 'package:swesshome/modules/presentation/screens/office_search_screen.dart';
import 'package:swesshome/modules/presentation/screens/rating_screen.dart';
import 'package:swesshome/modules/presentation/screens/recent_estates_orders_screen.dart';
import 'package:swesshome/modules/presentation/screens/reset_password_screen.dart';
import 'package:swesshome/modules/presentation/screens/saved_estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_location_screen.dart';
import 'package:swesshome/modules/presentation/screens/select_language_screen.dart';
import 'package:swesshome/modules/presentation/screens/settings_screen.dart';
import 'package:swesshome/modules/presentation/widgets/wonderful_alert_dialog.dart';
import 'package:swesshome/utils/helpers/my_internet_connection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swesshome/utils/services/network_helper.dart';

import '../../constants/api_paths.dart';
import '../../modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import '../../modules/business_logic_components/bloc/estate_types_bloc/estate_types_event.dart';
import '../../modules/business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
import '../../modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import '../../modules/business_logic_components/bloc/price_domains_bloc/price_domains_event.dart';
import '../../modules/business_logic_components/bloc/price_domains_bloc/price_domains_state.dart';
import '../../modules/presentation/screens/home_screen.dart';
import '../../modules/presentation/screens/navigation_bar_screen.dart';
import '../../modules/presentation/screens/update_new_version_screen.dart';

class AppRouter {
  late LocationsBloc locationsBloc;
  late RegionsBloc regionsBloc;
  late OwnershipTypeBloc ownershipTypeBloc;
  late EstateTypesBloc estateTypesBloc;
  late InteriorStatusesBloc interiorStatusesBloc;
  late EstateOfferTypesBloc estateOfferTypesBloc;
  late AreaUnitsBloc areaUnitsBloc;
  late PeriodTypesBloc periodTypesBloc;
  late PriceDomainsBloc priceDomainsBloc;
  late UserDataFetchBloc userDataFetchBloc;
  late UserLoginBloc userLoginBloc;
  late SystemVariablesBloc systemVariablesBloc;
  late ReportBloc reportBloc;

  String? userAccessToken;
  bool isThereStoredUser = false;
  bool isIntroductionScreenPassed = false;
  bool needUpdate = false;

  AppRouter() {
    userDataFetchBloc = UserDataFetchBloc(
      userAuthenticationRepository: UserAuthenticationRepository(),
    );
    userAccessToken = UserSharedPreferences.getAccessToken();
    isThereStoredUser = (userAccessToken != null);
    isIntroductionScreenPassed =
        ApplicationSharedPreferences.getWalkThroughPassState();
  }

  Route? onGenerateRoute(RouteSettings routerSettings) {
    switch (routerSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Builder(
            builder: (context) {
              return AnimatedSplashScreen.withScreenFunction(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                splash: SpinKitFoldingCube(
                  color: Theme.of(context).colorScheme.primary,
                  size: 0.25.sw,
                ),
                splashIconSize: 0.3.sw,
                duration: 0,
                screenFunction: () async {
                  // Check internet connection :
                  await checkInternetConnection(context);
                  // Check if there is new version
                  await isUpdateApp(
                      ApplicationSharedPreferences.getVersionAppState(),
                      context);
                  if (needUpdate) {
                    return const UpdateVersionScreen();
                  }
                  // Fetch BaseUrl :
                  await fetchBaseUrl();
                  // Fetch application data :
                  fetchApplicationData(context);
                  int seconds = 0;
                  while (true) {
                    await Future.delayed(const Duration(seconds: 1));
                    if (isFetchDataCompleted()) {
                      break;
                    }
                    if (seconds >= 50) {
                      await showFailureDialog(context);
                      exit(1);
                    }
                    seconds++;
                  }
                  // Language has not selected yet:
                  bool isLanguageSelected =
                      ApplicationSharedPreferences.getIsLanguageSelected();
                  if (!isLanguageSelected) {
                    return const SelectLanguageScreen();
                  }
                  // Language has selected before:
                  return (isIntroductionScreenPassed)
                      ? const NavigationBarScreen()
                      : const IntroductionScreen1();
                },
              );
            },
          ),
        );

      case IntroductionScreen1.id:
        return MaterialPageRoute(
          builder: (_) => const IntroductionScreen1(),
        );
      case IntroductionScreen2.id:
        return PageTransition(
          child: const IntroductionScreen2(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 200),
        );
      case IntroductionScreen3.id:
        return PageTransition(
          child: const IntroductionScreen3(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 200),
        );
      case IntroductionScreen4.id:
        return PageTransition(
          child: const IntroductionScreen4(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 200),
        );
      case HomeScreen.id:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case OfficeSearchScreen.id:
        return MaterialPageRoute(
          builder: (_) => const OfficeSearchScreen(),
        );
      case CreateOrderScreen.id:
        return MaterialPageRoute(
          builder: (_) => const CreateOrderScreen(),
        );
      case AuthenticationScreen.id:
        return MaterialPageRoute(
          builder: (_) => const AuthenticationScreen(),
        );
      case ResetPasswordScreen.id:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(
            phoneNumber: '',
          ),
        );
      case SearchLocationScreen.id:
        return MaterialPageRoute(
          builder: (_) => const SearchLocationScreen(),
        );
      case AfterEstateOrderScreen.id:
        return MaterialPageRoute(
          builder: (_) => const AfterEstateOrderScreen(),
        );
      case NotificationScreen.id:
        return MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        );
      case RecentEstateOrdersScreen.id:
        return MaterialPageRoute(
          builder: (_) => RecentEstateOrdersScreen(),
        );
      case CreatedEstatesScreen.id:
        return MaterialPageRoute(
          builder: (_) => CreatedEstatesScreen(),
        );
      case SavedEstatesScreen.id:
        return MaterialPageRoute(
          builder: (_) => const SavedEstatesScreen(),
        );
      case RatingScreen.id:
        return MaterialPageRoute(
          builder: (_) => const RatingScreen(),
        );
      case FAQScreen.id:
        return MaterialPageRoute(
          builder: (_) => const FAQScreen(),
        );
      case SettingsScreen.id:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      case LanguagesScreen.id:
        return MaterialPageRoute(
          builder: (_) => const LanguagesScreen(),
        );
        case EditProfileScreen.id:
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
        );
      default:
        return null;
    }
  }

  void fetchApplicationData(BuildContext context) {
    userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
    locationsBloc = BlocProvider.of<LocationsBloc>(context);
    regionsBloc = BlocProvider.of<RegionsBloc>(context);
    ownershipTypeBloc = BlocProvider.of<OwnershipTypeBloc>(context);
    estateTypesBloc = BlocProvider.of<EstateTypesBloc>(context);
    interiorStatusesBloc = BlocProvider.of<InteriorStatusesBloc>(context);
    estateOfferTypesBloc = BlocProvider.of<EstateOfferTypesBloc>(context);
    periodTypesBloc = BlocProvider.of<PeriodTypesBloc>(context);
    areaUnitsBloc = BlocProvider.of<AreaUnitsBloc>(context);
    priceDomainsBloc = BlocProvider.of<PriceDomainsBloc>(context);
    systemVariablesBloc = BlocProvider.of<SystemVariablesBloc>(context);
    reportBloc = BlocProvider.of<ReportBloc>(context);
    locationsBloc.add(LocationsFetchStarted());
    regionsBloc.add(RegionsFetchStarted());
    ownershipTypeBloc.add(OwnershipTypeFetchStarted());
    estateTypesBloc.add(EstateTypesFetchStarted());
    interiorStatusesBloc.add(InteriorStatusesFetchStarted());
    estateOfferTypesBloc.add(EstateOfferTypesFetchStarted());
    periodTypesBloc.add(PeriodTypesFetchStarted());
    areaUnitsBloc.add(AreaUnitsFetchStarted());
    priceDomainsBloc.add(PriceDomainsFetchStarted());
    systemVariablesBloc.add(SystemVariablesFetchStarted());
    reportBloc.add(ReportsFetchStarted());

    if (isThereStoredUser) {
      userDataFetchBloc.add(UserDataFetchStarted(token: userAccessToken!));
    }
  }

  bool isFetchDataCompleted() {
    bool isUserDataFetched = true;

    if (isIntroductionScreenPassed) {
      if (isThereStoredUser) {
        UserDataFetchState userDataFetchState = userDataFetchBloc.state;
        if (userDataFetchState is UserDataFetchComplete) {
          userLoginBloc.user = userDataFetchState.user;
        } else if (userDataFetchState is UserDataFetchError) {
          isUserDataFetched = true;
          UserSharedPreferences.clear();
        } else {
          isUserDataFetched = false;
        }
      }
    }
    return (locationsBloc.state is LocationsFetchComplete) &&
        (ownershipTypeBloc.state is OwnershipTypeFetchComplete) &&
        (estateTypesBloc.state is EstateTypesFetchComplete) &&
        (interiorStatusesBloc.state is InteriorStatusesFetchComplete) &&
        (estateOfferTypesBloc.state is EstateOfferTypesFetchComplete) &&
        (periodTypesBloc.state is PeriodTypesFetchComplete) &&
        (areaUnitsBloc.state is AreaUnitsFetchComplete) &&
        (priceDomainsBloc.state is PriceDomainsFetchComplete) &&
        (systemVariablesBloc.state is SystemVariablesFetchComplete) &&
        (reportBloc.state is ReportFetchComplete) &&
        isUserDataFetched;
  }

  Future showFailureDialog(BuildContext context) async {
    await showWonderfulAlertDialog(
      context,
      AppLocalizations.of(context)!.error,
      AppLocalizations.of(context)!.error_happened_when_connecting_with_server,
    );
  }

  checkInternetConnection(BuildContext context) async {
    if (!await MyInternetConnection.isConnected()) {
      await showWonderfulAlertDialog(
        context,
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.check_your_internet_connection,
        barrierDismissible: false,
        onDefaultButtonPressed: () {
          exit(0);
          Phoenix.rebirth(context);
          //RestartWidget.restartApp(context);
        },
        defaultButtonContent: AppLocalizations.of(context)!.restart_application,
        defaultButtonWidth: 200.w,
      );
    }
  }

  Future fetchBaseUrl() async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    try {
      response = await helper.get(fetchBaseUrlUrl);
    } catch (e) {
      rethrow;
    }
    //0 if you want to connect to pronet
    //1 if you want to connect to hostinger
    if (response.data == "1") {
      print("PPPRRRROOOOO");
      baseUrl = proNetBaseUrl;
      imagesBaseUrl = proNetImagesUrl;
    }
  }

  Future isUpdateApp(String version, context) async {
    NetworkHelper helper = NetworkHelper();
    Response response;
    bool isAndroid = true;
    try {
      response = await helper.post(
        isAndroid ? isUpdatedForAndroidUrl : isUpdatedForIosUrl,
        {"version1": version},
      );
    } catch (_) {
      rethrow;
    }
    //0 if do not need an update
    //1 if need an update
    if (response.data == "1") {
      needUpdate = true;
    }
    return response;
  }
}
