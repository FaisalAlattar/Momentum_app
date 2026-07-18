import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/appearance_controller.dart';
import '../../../../core/values/app_colors.dart';

class AppearanceView extends GetView<AppearanceController> {
  const AppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Listen to theme changes
    final colors = AppColors();
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Appearance',
          style: TextStyle(
            color: colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.pureBlack.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: controller.isDarkMode.value,
                        onChanged: controller.toggleDarkMode,
                        activeTrackColor: colors.lightBlue.withValues(
                          alpha: 0.5,
                        ),
                        activeThumbColor: colors.lightBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
