import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppearanceController extends GetxController {
  final isDarkMode = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize switch state to match current theme
    isDarkMode.value = Get.isDarkMode;
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    
    // Save preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }
}
