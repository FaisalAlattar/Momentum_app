import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordVisible = false.obs;
  final isEmailLoading = false.obs;
  final isGoogleLoading = false.obs;
  bool get isAnyLoading => isEmailLoading.value || isGoogleLoading.value;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isEmailLoading.value = true;
      await AuthService.to.loginWithEmail(email, password);
    } finally {
      isEmailLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;
      await AuthService.to.loginWithGoogle();
    } finally {
      isGoogleLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
