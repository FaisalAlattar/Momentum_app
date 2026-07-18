import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final authService = AuthService.to;

  Future<void> logout() async {
    await authService.logout();
    Get.offAllNamed(Routes.login);
  }
}

