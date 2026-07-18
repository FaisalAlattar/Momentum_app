import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Wait for exactly 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    
    final destination = AuthService.to.isLoggedIn ? Routes.main : Routes.login;

    // Smoothly transition to the appropriate screen
    Get.offNamed(destination);
  }
}
