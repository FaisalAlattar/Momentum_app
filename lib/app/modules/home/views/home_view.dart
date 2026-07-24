import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import '../controllers/home_controller.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/widgets/habit_card.dart';
import '../../../data/models/habit.dart';
import '../../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Listen to theme changes
    final colors = AppColors();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.bar_chart_outlined, color: colors.black),
          onPressed: () => Get.toNamed(Routes.statistics),
        ),
        title: Text(
          'Habits'.tr,
          style: TextStyle(
            color: colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCalendar(colors),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.pureBlack.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Obx(
                () => ImplicitlyAnimatedList<Habit>(
                  items: controller.habits.toList(),
                  areItemsTheSame: (a, b) => a.id == b.id,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  insertDuration: const Duration(milliseconds: 400),
                  removeDuration: const Duration(milliseconds: 400),
                  updateDuration: const Duration(milliseconds: 400),
                  itemBuilder: (context, animation, item, index) {
                    return SizeFadeTransition(
                      sizeFraction: 0.7,
                      curve: Curves.easeInOut,
                      animation: animation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Dismissible(
                          key: Key(item.id),
                          direction:
                              item.isCompletedOn(controller.selectedDay.value)
                              ? DismissDirection.endToStart
                              : DismissDirection.horizontal,
                          background: Container(
                            decoration: BoxDecoration(
                              color: colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          secondaryBackground: Container(
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await showDeleteDialog(
                                context,
                                colors,
                                item.id,
                                controller,
                              );
                            } else {
                              final bool confirm = await _showCompletionDialog(
                                context,
                                colors,
                                item,
                              );
                              if (confirm) {
                                final currentIndex = controller.habits
                                    .indexWhere((h) => h.id == item.id);
                                if (currentIndex != -1) {
                                  controller.toggleHabit(currentIndex);
                                }
                              }
                              return false; // Prevent removing from list
                            }
                          },
                          child: HabitCard(
                            habit: item,
                            selectedDate: controller.selectedDay.value,
                            onTap: () {
                              final currentIndex = controller.habits.indexWhere(
                                (h) => h.id == item.id,
                              );
                              if (currentIndex != -1) {
                                controller.toggleHabit(currentIndex);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(AppColors colors) {
    return Obx(() {
      final isWeekView = controller.calendarFormat.value == CalendarFormat.week;
      final today = DateTime.now();

      // Explicitly read reactive variables here so Obx tracks them
      final selectedDay = controller.selectedDay.value;
      final focusedDay = controller.focusedDay.value;

      // Calculate starting day of week for week view (6 days ago) to make today the far right column
      int startingWeekday = isWeekView
          ? today.subtract(const Duration(days: 6)).weekday
          : DateTime.monday; // Standard layout for Month view

      // TableCalendar expects weekday 1-7 (Monday-Sunday) mapping to enum index 0-6
      StartingDayOfWeek startingDay =
          StartingDayOfWeek.values[startingWeekday - 1];

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          // Force focusedDay to today when in week view to prevent scrolling to past/future selections
          focusedDay: isWeekView ? today : focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: controller.onDaySelected,
          calendarFormat: controller.calendarFormat.value,
          availableGestures: AvailableGestures
              .none, // Disable all horizontal and vertical swipes
          startingDayOfWeek: startingDay,
          onFormatChanged: (format) {},
          headerVisible: true,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            leftChevronVisible: !isWeekView, // Hide arrows in week view
            rightChevronVisible: !isWeekView,
            leftChevronIcon: Icon(Icons.chevron_left, color: colors.black),
            rightChevronIcon: Icon(Icons.chevron_right, color: colors.black),
            titleTextStyle: TextStyle(
              color: colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: colors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: colors.black.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarStyle: CalendarStyle(
            defaultTextStyle: TextStyle(color: colors.black, fontSize: 16),
            weekendTextStyle: TextStyle(color: colors.black, fontSize: 16),
            outsideDaysVisible: false,
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: colors.lightBlue, width: 1.5),
            ),
            todayTextStyle: TextStyle(
              color: colors.lightBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            selectedDecoration: BoxDecoration(
              gradient: colors.blueBlackGradient,
              shape: BoxShape.circle,
            ),
            selectedTextStyle: TextStyle(
              color: colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          onHeaderTapped: (_) => controller.toggleCalendarFormat(),
        ),
      );
    });
  }

  Future<bool> _showCompletionDialog(
    BuildContext context,
    AppColors colors,
    Habit habit,
  ) async {
    final bool isCompleted = habit.isCompletedOn(controller.selectedDay.value);
    final String actionText = isCompleted
        ? 'Mark as Incomplete'
        : 'Mark as Complete';
    final String message = isCompleted
        ? 'Are you sure you want to mark this habit as incomplete?'
        : 'Are you sure you want to mark this habit as complete?';

    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.all(24),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              actionsPadding: const EdgeInsets.all(24),
              title: Column(
                children: [
                  Icon(
                    isCompleted ? Icons.undo : Icons.check_circle_outline,
                    color: colors.lightBlue,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    actionText,
                    style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                message,
                style: TextStyle(
                  color: colors.black.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.lightBlue,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.lightBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  static Future<bool> showDeleteDialog(
    BuildContext context,
    AppColors colors,
    String habitId,
    HomeController controller,
  ) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              backgroundColor: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              titlePadding: const EdgeInsets.all(24),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              actionsPadding: const EdgeInsets.all(24),
              title: Column(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Delete Habit',
                    style: TextStyle(
                      color: colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              content: Text(
                'Are you sure you want to delete this habit? This action cannot be undone.',
                style: TextStyle(
                  color: colors.black.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.lightBlue,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: colors.lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                          controller.deleteHabit(habitId);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }
}
