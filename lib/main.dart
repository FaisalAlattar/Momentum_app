import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/services/auth_service.dart';
import 'app/services/firestore_service.dart';
import 'app/routes/app_pages.dart';
import 'core/localization/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Get.put(AuthService());
  Get.put(FirestoreService());

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final languageCode = prefs.getString('languageCode') ?? 'en';
  final countryCode = prefs.getString('countryCode') ?? 'US';

  runApp(MomentumApp(
    isDarkMode: isDarkMode,
    locale: Locale(languageCode, countryCode),
  ));
}

class MomentumApp extends StatelessWidget {
  final bool isDarkMode;
  final Locale locale;
  
  const MomentumApp({super.key, this.isDarkMode = false, required this.locale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Momentum',
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      translations: AppTranslations(),
      locale: locale,
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    );
  }
}
