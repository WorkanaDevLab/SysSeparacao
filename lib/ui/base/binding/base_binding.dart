import 'package:flutterbase/ui/base/controller/base_controller.dart';
import 'package:get/get.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BaseController());
  }
}