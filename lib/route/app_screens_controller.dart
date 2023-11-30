import 'package:flutterbase/ui/base/binding/base_binding.dart';
import 'package:flutterbase/ui/base/ui/base_screen.dart';
import 'package:flutterbase/ui/login/binding/login_binding.dart';
import 'package:flutterbase/ui/login/ui/main_screen.dart';
import 'package:flutterbase/ui/login/ui/settings_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../ui/login/ui/login_screen.dart';
import 'app_screens_name.dart';

abstract class AppScreens {
  static final pages = <GetPage>[
    GetPage(name: AppScreensNames.base, page: () => const BaseScreen(), bindings: [BaseBinding()]),
    GetPage(name: AppScreensNames.login, page: () => const LoginScreen(), bindings: [LoginBinding()]),
    GetPage(name: AppScreensNames.main, page: () => const MainScreen(), bindings: []),
    GetPage(name: AppScreensNames.settings, page: () => const SettingsScreen(), bindings: []),
  ];
}
