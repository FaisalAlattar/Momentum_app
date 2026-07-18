import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final RxString selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    selectedLanguage.value = languageCode;
  }

  Future<void> changeLanguage(String languageCode, String countryCode) async {
    selectedLanguage.value = languageCode;
    
    // Update GetX Locale
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
    
    // Save locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    await prefs.setString('countryCode', countryCode);
  }
}
