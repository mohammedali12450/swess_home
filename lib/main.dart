import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swesshome/config/routes/app_router.dart';
import 'package:swesshome/core/storage/shared_preferences/application_shared_preferences.dart';
import 'package:swesshome/core/storage/shared_preferences/recent_searches_shared_preferences.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_bloc/estate_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/estate_order_bloc/estate_order_bloc.dart';
import 'package:swesshome/modules/business_logic_components/bloc/user_login_bloc/user_login_bloc.dart';
import 'package:swesshome/modules/data/repositories/estate_order_repository.dart';
import 'package:swesshome/modules/data/repositories/estate_repository.dart';
import 'package:swesshome/modules/data/repositories/user_authentication_repository.dart';
import 'core/storage/shared_preferences/user_shared_preferences.dart';
import 'modules/business_logic_components/bloc/area_units_bloc/area_units_bloc.dart';
import 'modules/business_logic_components/bloc/estate_offer_types_bloc/estate_offer_types_bloc.dart';
import 'modules/business_logic_components/bloc/estate_types_bloc/estate_types_bloc.dart';
import 'modules/business_logic_components/bloc/interior_statuses_bloc/interior_statuses_bloc.dart';
import 'modules/business_logic_components/bloc/location_bloc/locations_bloc.dart';
import 'modules/business_logic_components/bloc/ownership_type_bloc/ownership_type_bloc.dart';
import 'modules/business_logic_components/bloc/period_types_bloc/period_types_bloc.dart';
import 'modules/business_logic_components/bloc/price_domains_bloc/price_domains_bloc.dart';
import 'modules/business_logic_components/bloc/send_estate_bloc/send_estate_bloc.dart';
import 'modules/data/repositories/area_units_repository.dart';
import 'modules/data/repositories/estate_offer_types_repository.dart';
import 'modules/data/repositories/estate_types_repository.dart';
import 'modules/data/repositories/interior_statuses_repository.dart';
import 'modules/data/repositories/ownership_type_repository.dart';
import 'modules/data/repositories/period_types_repository.dart';
import 'modules/data/repositories/price_domains_repository.dart';

void main() async {
  // Shared preferences initializing
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();
  await ApplicationSharedPreferences.init();
  await RecentSearchesSharedPreferences.init();

  // Shared preferences clearing :
  // await UserSharedPreferences.clear();
  // await ApplicationSharedPreferences.clear();
  // await RecentSearchesSharedPreferences.clear();

  // Run application:
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
