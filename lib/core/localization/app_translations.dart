import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'Habits': 'Habits',
          'Settings': 'Settings',
          'Profile': 'Profile',
          'General': 'General',
          'Appearance': 'Appearance',
          'Notifications': 'Notifications',
          'Statistics': 'Statistics',
          'Language': 'Language',
          'About': 'About',
          'Log out': 'Log out',
          'Habit Completion': 'Habit Completion',
        },
        'ar_SA': {
          'Habits': 'العادات',
          'Settings': 'الإعدادات',
          'Profile': 'الملف الشخصي',
          'General': 'عام',
          'Appearance': 'المظهر',
          'Notifications': 'الإشعارات',
          'Statistics': 'الإحصائيات',
          'Language': 'اللغة',
          'About': 'حول',
          'Log out': 'تسجيل الخروج',
          'Habit Completion': 'إكمال العادات',
        },
      };
}
