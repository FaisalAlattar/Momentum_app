import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_colors.dart';

class AddHabitController extends GetxController {
  final nameController = TextEditingController();

  final selectedIcon = Rx<IconData>(Icons.fitness_center);
  final selectedColor = Rx<Color?>(null); // Null means use default gradient
  final selectedStartDate = Rx<DateTime>(DateTime.now());
  final selectedDuration = Rx<int>(7);

  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.menu_book,
    Icons.water_drop,
    Icons.code,
    Icons.self_improvement,
    Icons.directions_run,
    Icons.monitor_weight,
    Icons.bed,
    Icons.local_dining,
    Icons.music_note,
  ];

  final List<Color> availableColors = [
    const Color(0xFFF59E0B), // Amber
    const Color(0xFFF43F5E), // Rose
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFFEC4899), // Pink
    const Color(0xFF3B82F6), // Blue
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFEA580C), // Orange
    const Color(0xFF64748B), // Slate
  ];

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void selectIcon(IconData icon) {
    selectedIcon.value = icon;
  }

  void selectColor(Color color) {
    if (selectedColor.value == color) {
      selectedColor.value = null; // Toggle off to default gradient
    } else {
      selectedColor.value = color;
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final colors = AppColors();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Get.isDarkMode
                ? ColorScheme.dark(
                    primary: colors.lightBlue,
                    onPrimary: colors.pureWhite,
                    surface: colors.surface,
                    onSurface: colors.textPrimary,
                  )
                : ColorScheme.light(
                    primary: colors.lightBlue,
                    onPrimary: colors.pureWhite,
                    surface: colors.surface,
                    onSurface: colors.textPrimary,
                  ),
            dialogTheme: DialogThemeData(backgroundColor: colors.surface),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: colors.lightBlue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedStartDate.value = picked;
    }
  }
}
