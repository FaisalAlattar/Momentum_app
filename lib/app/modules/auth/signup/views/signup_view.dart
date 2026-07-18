import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';
import '../../../../../core/values/app_colors.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.blueBlackGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash_logo_m_only.png',
                    height: 60,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      color: colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start tracking your habits today.',
                    style: TextStyle(
                      color: colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    hintText: 'Full Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.nameController,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: Icons.email_outlined,
                    controller: controller.emailController,
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !controller.isPasswordVisible.value,
                      onTogglePassword: controller.togglePasswordVisibility,
                      controller: controller.passwordController,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => CustomTextField(
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !controller.isPasswordVisible.value,
                      onTogglePassword: controller.togglePasswordVisibility,
                      controller: controller.confirmPasswordController,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(
                    () => PrimaryButton(
                      text: 'SIGN UP',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.isLoading.value
                          ? () {}
                          : controller.signup,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    // using Get.back() creates a clean pop animation back to the login screen
                    onTap: () => Get.back(),
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          color: colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
