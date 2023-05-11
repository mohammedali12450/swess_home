import 'package:get_it/get_it.dart';
import 'package:swesshome/modules/data/services/google_sign_in_services.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocatorApp() async {
  locator.registerLazySingleton(() => GoogleSignInService());
}
