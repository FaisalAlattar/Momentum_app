import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../settings/controllers/settings_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    
    // We need to provide the controllers for the tabs so they are available when IndexedStack builds them
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
