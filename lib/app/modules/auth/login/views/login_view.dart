import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../../core/values/app_colors.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/secondary_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash_logo_m_only.png',
                    height: 80,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue your journey.',
                    style: TextStyle(
                      color: colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
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
                  const SizedBox(height: 40),
                  Obx(
                    () => PrimaryButton(
                      text: 'LOGIN',
                      isLoading: controller.isEmailLoading.value,
                      onPressed: controller.isAnyLoading
                          ? () {}
                          : controller.login,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SecondaryButton(
                      text: 'Continue with Google',
                      iconAsset: 'assets/images/google_logo.png',
                      isLoading: controller.isGoogleLoading.value,
                      onPressed: controller.isAnyLoading
                          ? () {}
                          : controller.loginWithGoogle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.signup),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: colors.white.withValues(alpha: 0.8),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
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
