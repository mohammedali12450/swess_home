import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:swesshome/config/routes/app_router.dart';
import 'package:swesshome/constants/assets_paths.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/data/repositories/reports_repository.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'config/themes/my_themes.dart';
import 'constants/application_constants.dart';
import 'core/functions/store_notification.dart';
import 'core/models/l10n.dart';
import 'core/notifications/firebase_notifications.dart';
import 'core/notifications/local_notifications.dart';
import 'core/storage/shared_preferences/notifications_shared_preferences.dart';
import 'core/storage/shared_preferences/shared_preferences_controllers.dart';
import 'modules/business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import 'modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'modules/business_logic_components/bloc/fcm_bloc/fcm_bloc.dart';
import 'modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'modules/business_logic_components/bloc/notifications_bloc/notifications_bloc.dart';
import 'modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'modules/business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import 'modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'modules/business_logic_components/bloc/send_estate_bloc/send_estate_bloc.dart';
import 'modules/business_logic_components/bloc/system_variables_bloc/system_variables_bloc.dart';
import 'modules/business_logic_components/cubits/notifications_cubit.dart';
import 'modules/data/providers/locale_provider.dart';
import 'modules/data/providers/theme_provider.dart';
import 'modules/data/repositories/area_units_repository.dart';
import 'modules/data/repositories/estate_offer_types_repository.dart';
import 'modules/data/repositories/estate_types_repository.dart';
import 'modules/data/repositories/fcm_token_repository.dart';
import 'modules/data/repositories/interior_statuses_repository.dart';
import 'modules/data/repositories/notifications_repository.dart';
import 'modules/data/repositories/ownership_type_repository.dart';
import 'modules/data/repositories/period_types_repository.dart';
import 'modules/data/repositories/price_domains_repository.dart';
import 'modules/data/repositories/system_variables_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const bool _clearSharedPreferences = false;

void main() async {
  // Widget binding:
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialize //
  await initializeFirebase();

  // Shared preferences initializing
  await initializeSharedPreferences();

  // Shared preferences clearing :
  if (_clearSharedPreferences) {
    await clearSharedPreferences();
  }

  // Run application:
  if (!_clearSharedPreferences) {
    runApp(
      Phoenix(
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppRouter appRouter = AppRouter();
  late FirebaseMessaging messaging;
  late NotificationsCubit notificationsCubit;
  late ThemeMode initialThemeMode;
  Locale? initialLocale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Bind observer :
    WidgetsBinding.instance!.addObserver(this);

    // initialize notifications count :
    notificationsCubit = NotificationsCubit(NotificationsSharedPreferences.getNotificationsCount());

    // Firebase messages initializing :
    initializeFirebaseMessaging();

    // initialize application locale:
    String? storedLocale = ApplicationSharedPreferences.getLanguageCode();
    if (storedLocale == null) {
      initialLocale = Locale(window.locale.languageCode == "ar" ? "ar" : "en");
    } else {
      initialLocale = Locale(storedLocale);
    }

    // initialize application theme mode:
    bool? isDarkMode = ApplicationSharedPreferences.getIsDarkMode();
    if (isDarkMode != null) {
      initialThemeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    } else {
      initialThemeMode = ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(swessHomeIconPath), context);

    return MultiBlocProvider(
      providers: [
        // Global Blocs:
        BlocProvider<UserLoginBloc>(
          create: (_) => UserLoginBloc(UserAuthenticationRepository()),
        ),
        BlocProvider(
          create: (_) => LocationsBloc(),
        ),
        BlocProvider(
          create: (_) => OwnershipTypeBloc(
            OwnershipTypeRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => SystemVariablesBloc(
            SystemVariablesRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => EstateTypesBloc(
            EstateTypesRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => InteriorStatusesBloc(
            InteriorStatusesRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => EstateOfferTypesBloc(
            EstateOfferTypesRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => PeriodTypesBloc(
            PeriodTypeRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => AreaUnitsBloc(
            AreaUnitsRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => PriceDomainsBloc(
            PriceDomainsRepository(),
          ),
        ),
        BlocProvider<NotificationsCubit>(
          lazy: false,
          create: (_) => notificationsCubit,
        ),
        BlocProvider(
          lazy: false,
          create: (_) => NotificationsBloc(NotificationRepository()),
        ),
        BlocProvider(
          create: (_) => EstateBloc(
            EstateRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => EstateOrderBloc(
            EstateOrderRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => SendEstateBloc(
            estateRepository: EstateRepository(),
          ),
        ),
        BlocProvider(
          create: (_) => FcmBloc(fcmTokenRepository: FcmTokenRepository()),
        ),
        BlocProvider(
          create: (_) => ReportBloc(ReportsRepository()),
        ),
      ],
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => LocaleProvider(initialLocale),
            ),
            ChangeNotifierProvider(
              create: (_) => ThemeProvider(initialThemeMode),
            ),
          ],
          builder: (context, child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            final localeProvider = Provider.of<LocaleProvider>(context);

            return ScreenUtilInit(
              designSize: const Size(428, 926),
              minTextAdapt: true,
              splitScreenMode: false,
              builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                onGenerateRoute: appRouter.onGenerateRoute,
                initialRoute: '/',
                builder: (context, widget) {
                  ScreenUtil.setContext(context);
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: widget!);
                },
                supportedLocales: L10n.all,
                locale: localeProvider.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                themeMode: themeProvider.themeMode,
                theme: MyThemes.lightTheme(context),
                darkTheme: MyThemes.darkTheme(context),
              ),
            );
          }),
    );
  }

  Future initializeFirebaseMessaging() async {
    // initialize firebase messaging :
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      firebaseToken = value;
    });

    // on foreground message :
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          await storeNotification();
          notificationsCubit.checkNewNotifications();
          debugPrint(notification.title);
          debugPrint(notification.body);
          // show local notification :
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                  androidNotificationsChannel.id, androidNotificationsChannel.name,
                  channelDescription: androidNotificationsChannel.description,
                  color: Colors.blue,
                  playSound: true),
            ),
          );
        }
      },
    );

    // on message opened App :
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {}
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      checkNewNotifications();
    }
  }

  Future checkNewNotifications() async {
    await NotificationsSharedPreferences.init();
    await NotificationsSharedPreferences.reload();
    notificationsCubit.checkNewNotifications();
  }
}
