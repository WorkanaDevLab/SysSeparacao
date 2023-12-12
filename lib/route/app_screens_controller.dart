import 'package:flutterbase/ui/login/binding/login_binding.dart';
import 'package:flutterbase/ui/login/binding/main_binding.dart';
import 'package:flutterbase/ui/login/ui/main_screen.dart';
import 'package:flutterbase/ui/login/ui/settings_screen.dart';
import 'package:flutterbase/ui/splashscreen/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../ui/login/ui/login_screen.dart';
import 'app_screens_name.dart';

abstract class AppScreens {
  static final pages = <GetPage>[
    GetPage(name: AppScreensNames.base, page: () => const SplashScreen()),
    GetPage(name: AppScreensNames.login, page: () => const LoginScreen(), bindings: [LoginBinding()]),
    GetPage(name: AppScreensNames.main, page: () => const MainScreen(), bindings: [MainBinding()]),
    GetPage(name: AppScreensNames.settings, page: () => const SettingsScreen(), bindings: []),
  ];
}
