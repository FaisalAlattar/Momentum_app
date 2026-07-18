import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/language_controller.dart';
import '../../../../core/values/app_colors.dart';

class LanguageView extends GetView<LanguageController> {
  const LanguageView({super.key});

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
          'Language'.tr,
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
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedLanguage.value,
                      isExpanded: true,
                      dropdownColor: colors.surface,
                      icon: Icon(Icons.keyboard_arrow_down, color: colors.black),
                      style: TextStyle(
                        color: colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          if (newValue == 'en') {
                            controller.changeLanguage('en', 'US');
                          } else if (newValue == 'ar') {
                            controller.changeLanguage('ar', 'SA');
                          }
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text('العربية (Arabic)'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
