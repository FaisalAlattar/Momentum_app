import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  void onAddHabitPressed() {
    // We delegate the FAB action to the HomeController so that it remains 
    // responsible for its own logic, as requested.
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().onAddHabitPressed();
    }
  }
}
