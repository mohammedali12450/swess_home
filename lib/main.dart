import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:swesshome/config/routes/app_router.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/reports_bloc/reports_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/data/repositories/reports_repository.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'constants/application_constants.dart';
import 'core/functions/store_notification.dart';
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
  }

  @override
  Widget build(BuildContext context) {
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
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenerateRoute,
        initialRoute: '/',
      ),
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
    print(state.name);
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
