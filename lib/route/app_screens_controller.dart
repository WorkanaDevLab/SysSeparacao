import 'package:flutterbase/ui/base/binding/base_binding.dart';
import 'package:flutterbase/ui/base/ui/base_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_screens_name.dart';

abstract class AppScreens {
  static final pages = <GetPage>[
    GetPage(name: AppScreensNames.base, page: () => const BaseScreen(), bindings: [BaseBinding()]),
  ];
}
