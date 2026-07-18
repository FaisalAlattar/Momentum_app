import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  Future<void> signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmPasswordController.text.trim();
    
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    if (password != confirm) {
      Get.snackbar('Error', 'Passwords do not match', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;
      await AuthService.to.registerWithEmail(name, email, password);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
