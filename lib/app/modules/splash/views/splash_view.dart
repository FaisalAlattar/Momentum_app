import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../../core/values/app_colors.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().background,
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo_m_only.png',
          width: 160,
          height: 160,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
