import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../data/models/habit.dart';
import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import '../widgets/add_habit_bottom_sheet.dart';

class HomeController extends GetxController {
  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;
  final calendarFormat = CalendarFormat.week.obs;

  final allHabits = <Habit>[].obs;
  final habits = <Habit>[].obs;

  @override
  void onInit() {
    super.onInit();
    final uid = AuthService.to.firebaseUser.value?.uid;
    if (uid != null) {
      allHabits.bindStream(FirestoreService.to.getHabitsStream(uid));
    }
    // Filter habits whenever the allHabits list changes (e.g. from stream update)
    ever(allHabits, (_) => _filterHabitsForSelectedDay());
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
    _filterHabitsForSelectedDay();
  }

  void _filterHabitsForSelectedDay() {
    final targetDate = DateTime(
      selectedDay.value.year,
      selectedDay.value.month,
      selectedDay.value.day,
    );

    final filtered = allHabits.where((habit) {
      if (habit.startDate == null) return true;
      final habitStartDate = DateTime(
        habit.startDate!.year,
        habit.startDate!.month,
        habit.startDate!.day,
      );
      final habitEndDate = habitStartDate.add(Duration(days: habit.durationDays));
      // Only show habits if selected day is on or after the start date and before the end date
      return !targetDate.isBefore(habitStartDate) && targetDate.isBefore(habitEndDate);
    }).toList();

    filtered.sort((a, b) {
      final aCompleted = a.isCompletedOn(selectedDay.value);
      final bCompleted = b.isCompletedOn(selectedDay.value);
      if (aCompleted && !bCompleted) return 1;
      if (!aCompleted && bCompleted) return -1;
      return b.createdAt.compareTo(a.createdAt);
    });

    habits.assignAll(filtered);
  }

  void toggleCalendarFormat() {
    if (calendarFormat.value == CalendarFormat.week) {
      calendarFormat.value = CalendarFormat.month;
    } else {
      calendarFormat.value = CalendarFormat.week;
    }
  }

  void toggleHabit(int index) {
    final habit = habits[index];
    final date = selectedDay.value;
    final isCompleted = habit.isCompletedOn(date);

    final updatedHistory = Map<String, bool>.from(habit.completionHistory);
    final key = DateFormat('yyyy-MM-dd').format(date);
    updatedHistory[key] = !isCompleted;

    final updatedHabit = Habit(
      id: habit.id,
      name: habit.name,
      icon: habit.icon,
      color: habit.color,
      startDate: habit.startDate,
      createdAt: habit.createdAt,
      durationDays: habit.durationDays,
      completionHistory: updatedHistory,
    );

    final uid = AuthService.to.firebaseUser.value?.uid;
    if (uid != null) {
      FirestoreService.to.updateHabit(uid, updatedHabit);
    }
  }

  void onAddHabitPressed() {
    Get.bottomSheet(
      const AddHabitBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> addHabit(String name, IconData icon, Color? color, DateTime startDate, int durationDays) async {
    final newHabit = Habit(
      id: '', // Firestore will generate the ID
      name: name,
      icon: icon,
      color: color,
      startDate: startDate,
      createdAt: DateTime.now(),
      durationDays: durationDays,
      completionHistory: {},
    );

    final uid = AuthService.to.firebaseUser.value?.uid;
    if (uid != null) {
      try {
        await FirestoreService.to.addHabit(uid, newHabit);
      } catch (e) {
        debugPrint('Error adding habit: $e');
        Get.snackbar(
          'Error',
          'Failed to add habit. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Authentication Error',
        'You must be logged in to add a habit.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> deleteHabit(String habitId) async {
    final uid = AuthService.to.firebaseUser.value?.uid;
    if (uid == null) return false;

    try {
      await FirestoreService.to.deleteHabit(uid, habitId);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete habit.');
      return false;
    }
  }
}
