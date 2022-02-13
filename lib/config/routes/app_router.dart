import 'dart:io';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swesshome/constants/colors.dart';
import 'package:swesshome/constants/design_constants.dart';
import 'package:swesshome/core/functions/app_theme_information.dart';
import 'package:swesshome/core/functions/screen_informations.dart';
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
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_types_bloc/estate_types_state.dart';
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
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/price_domains_bloc/price_domains_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_event.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_data_fetch_bloc/user_data_fetch_state.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'package:swesshome/modules/presentation/screens/after_estate_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/authentication_screen.dart';
import 'package:swesshome/modules/presentation/screens/create_order_screen.dart';
import 'package:swesshome/modules/presentation/screens/estates_screen.dart';
import 'package:swesshome/modules/presentation/screens/home_screen.dart';
import 'package:swesshome/modules/presentation/screens/office_search_screen.dart';
import 'package:swesshome/modules/presentation/screens/search_location_screen.dart';
import 'package:swesshome/modules/presentation/widgets/my_button.dart';
import 'package:swesshome/utils/helpers/responsive.dart';

class AppRouter {
  late LocationsBloc locationsBloc;
  late OwnershipTypeBloc ownershipTypeBloc;
  late EstateTypesBloc estateTypesBloc;
  late InteriorStatusesBloc interiorStatusesBloc;
  late EstateOfferTypesBloc estateOfferTypesBloc;
  late AreaUnitsBloc areaUnitsBloc;
  late PeriodTypesBloc periodTypesBloc;
  late PriceDomainsBloc priceDomainsBloc;
  late UserDataFetchBloc userDataFetchBloc;
  late UserLoginBloc userLoginBloc;

  String? userAccessToken;
  bool isThereStoredUser = false;
  bool isIntroductionScreenPassed = false;

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
              initializeApplicationConstants(context);
              return AnimatedSplashScreen.withScreenFunction(
                backgroundColor: baseColor,
                splash: SpinKitFoldingCube(
                  color: secondaryColor,
                  size: Res.width(screenWidth / 4),
                ),
                splashIconSize: Res.width(screenWidth / 1.5),
                duration: 0,
                screenFunction: () async {
                  fetchApplicationData(context);
                  int seconds = 0;
                  while (true) {
                    await Future.delayed(const Duration(seconds: 1));
                    if (isFetchDataCompleted()) {
                      break;
                    }
                    if (seconds >= 50) {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: const Text(
                            "حدث خطأ أثناء الاتصال بالسيرفر",
                            textAlign: TextAlign.right,
                          ),
                          title: const Text(
                            "خطأ",
                            textAlign: TextAlign.right,
                          ),
                          actions: [
                            MyButton(
                              width: Res.width(200),
                              child: Text(
                                "تم",
                                style: textStyling(S.s14, W.w5, C.wh),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: secondaryColor,
                            )
                          ],
                        ),
                      );
                      exit(1);
                    }
                    seconds++;
                  }
                  return (isIntroductionScreenPassed)
                      ? const HomeScreen()
                      : IntroductionScreen1();
                },
              );
            },
          ),
        );

      case IntroductionScreen1.id:
        return MaterialPageRoute(
          builder: (_) => IntroductionScreen1(),
        );
      case IntroductionScreen2.id:
        return PageTransition(
          child: IntroductionScreen2(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 200),
        );
      case IntroductionScreen3.id:
        return PageTransition(
          child: IntroductionScreen3(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 200),
        );
      case IntroductionScreen4.id:
        return PageTransition(
          child: IntroductionScreen4(),
          type: PageTransitionType.rightToLeft,
          reverseDuration: Duration(milliseconds: 200),
          duration: Duration(milliseconds: 200),
        );
      case HomeScreen.id:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case OfficeSearchScreen.id:
        return MaterialPageRoute(
          builder: (_) => OfficeSearchScreen(),
        );
      case CreateOrderScreen.id:
        return MaterialPageRoute(
          builder: (_) => CreateOrderScreen(),
        );
      case AuthenticationScreen.id:
        return MaterialPageRoute(
          builder: (_) => AuthenticationScreen(),
        );
        case SearchLocationScreen.id:
        return MaterialPageRoute(
          builder: (_) => SearchLocationScreen(),
        );
        case AfterEstateOrderScreen.id:
        return MaterialPageRoute(
          builder: (_) => AfterEstateOrderScreen(),
        );
      default:
        return null;
    }
  }

  void initializeApplicationConstants(BuildContext context) {
    screenWidth = getScreenWidth(context);
    screenHeight = getScreenHeight(context);
    fullScreenHeight = getFullScreenHeight(context);
  }

  void fetchApplicationData(BuildContext context) {
    userLoginBloc = BlocProvider.of<UserLoginBloc>(context);
    locationsBloc = BlocProvider.of<LocationsBloc>(context);
    ownershipTypeBloc = BlocProvider.of<OwnershipTypeBloc>(context);
    estateTypesBloc = BlocProvider.of<EstateTypesBloc>(context);
    interiorStatusesBloc = BlocProvider.of<InteriorStatusesBloc>(context);
    estateOfferTypesBloc = BlocProvider.of<EstateOfferTypesBloc>(context);
    periodTypesBloc = BlocProvider.of<PeriodTypesBloc>(context);
    areaUnitsBloc = BlocProvider.of<AreaUnitsBloc>(context);
    priceDomainsBloc = BlocProvider.of<PriceDomainsBloc>(context);
    locationsBloc.add(LocationsFetchStarted());
    ownershipTypeBloc.add(OwnershipTypeFetchStarted());
    estateTypesBloc.add(EstateTypesFetchStarted());
    interiorStatusesBloc.add(InteriorStatusesFetchStarted());
    estateOfferTypesBloc.add(EstateOfferTypesFetchStarted());
    periodTypesBloc.add(PeriodTypesFetchStarted());
    areaUnitsBloc.add(AreaUnitsFetchStarted());
    priceDomainsBloc.add(PriceDomainsFetchStarted());
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
        isUserDataFetched;
  }
}
