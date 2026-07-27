import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_habit_controller.dart';
import '../controllers/home_controller.dart';
import 'package:intl/intl.dart';
import '../../../../core/values/app_colors.dart';

class AddHabitBottomSheet extends StatelessWidget {
  const AddHabitBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    // Initialize controller for this bottom sheet instance
    final controller = Get.put(AddHabitController());

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 1.0,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: _buildDragHandle(colors),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 24.0,
                          right: 24.0,
                          top: 8.0,
                          bottom: 80.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'New Habit'.tr,
                              style: TextStyle(
                                color: colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 1. Habit Name
                            _buildSectionTitle('Habit Name'.tr, colors),
                            const SizedBox(height: 6),
                            _buildNameInput(controller, colors),
                            const SizedBox(height: 16),

                            // 2. Start Date
                            _buildSectionTitle('Start Date'.tr, colors),
                            const SizedBox(height: 6),
                            _buildStartDateSelection(
                              controller,
                              context,
                              colors,
                            ),
                            const SizedBox(height: 16),

                            // 3. Goal Duration
                            _buildSectionTitle('Goal Duration'.tr, colors),
                            const SizedBox(height: 6),
                            _buildDurationSelection(controller, colors),
                            const SizedBox(height: 16),

                            // 3. Habit Icon
                            _buildSectionTitle('Icon'.tr, colors),
                            const SizedBox(height: 6),
                            _buildIconSelection(controller, colors),
                            const SizedBox(height: 16),

                            // 4. Habit Color
                            _buildSectionTitle('Color'.tr, colors),
                            const SizedBox(height: 6),
                            _buildColorSelection(controller, colors),
                            const SizedBox(height: 24),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: _buildAddButton(controller, colors),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle(AppColors colors) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColors colors) {
    return Text(
      title,
      style: TextStyle(
        color: colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildNameInput(AddHabitController controller, AppColors colors) {
    return TextField(
      controller: controller.nameController,
      style: TextStyle(color: colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: 'e.g. Read a book'.tr,
        hintStyle: TextStyle(color: colors.black.withValues(alpha: 0.4)),
        filled: true,
        fillColor: colors.surfaceHighlight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildStartDateSelection(
    AddHabitController controller,
    BuildContext context,
    AppColors colors,
  ) {
    return GestureDetector(
      onTap: () => controller.pickDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceHighlight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: colors.black.withValues(alpha: 0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Obx(() {
              final date = controller.selectedStartDate.value;
              final formattedDate = DateFormat('d MMMM, yyyy').format(date);
              return Text(
                formattedDate,
                style: TextStyle(
                  color: colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              );
            }),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: colors.black.withValues(alpha: 0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationSelection(
    AddHabitController controller,
    AppColors colors,
  ) {
    return Obx(() {
      final options = [7, 30, 90];
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: options.map((duration) {
          final isSelected = controller.selectedDuration.value == duration;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectedDuration.value = duration,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.lightBlue
                      : colors.surfaceHighlight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colors.lightBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$duration Days'.tr,
                  style: TextStyle(
                    color: isSelected
                        ? colors.white
                        : colors.black.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildIconSelection(AddHabitController controller, AppColors colors) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.availableIcons.map((icon) {
          final isSelected = controller.selectedIcon.value == icon;
          return GestureDetector(
            onTap: () => controller.selectIcon(icon),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? colors.lightBlue : colors.surfaceHighlight,
                shape: BoxShape.circle,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors.lightBlue.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? colors.white
                    : colors.black.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildColorSelection(AddHabitController controller, AppColors colors) {
    return Obx(
      () => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // Default Gradient Option
          GestureDetector(
            onTap: () => controller.selectedColor.value = null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.blueBlackGradient,
                border: controller.selectedColor.value == null
                    ? Border.all(color: colors.white, width: 3)
                    : null,
                boxShadow: controller.selectedColor.value == null
                    ? [
                        BoxShadow(
                          color: colors.lightBlue.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: controller.selectedColor.value == null
                  ? Icon(Icons.check, color: colors.white, size: 20)
                  : null,
            ),
          ),
          // Custom Color Options
          ...controller.availableColors.map((color) {
            final isSelected = controller.selectedColor.value == color;
            return GestureDetector(
              onTap: () => controller.selectColor(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: colors.background, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: isSelected
                    ? Icon(Icons.check, color: colors.white, size: 20)
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddButton(AddHabitController controller, AppColors colors) {
    return GestureDetector(
      onTap: () {
        final name = controller.nameController.text.trim();
        if (name.isNotEmpty) {
          Get.find<HomeController>().addHabit(
            name,
            controller.selectedIcon.value,
            controller.selectedColor.value,
            controller.selectedStartDate.value,
            controller.selectedDuration.value,
          );
          Get.back();
          // We let GetX handle the deletion of the controller when the route is fully popped.
        } else {
          Get.snackbar(
            'Missing Name'.tr,
            'Please enter a habit name.'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: colors.surface,
            colorText: colors.textPrimary,
            margin: const EdgeInsets.all(16),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: colors.blueBlackGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.lightBlue.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Add Habit'.tr,
          style: TextStyle(
            color: colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
