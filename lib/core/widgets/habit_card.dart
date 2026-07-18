import 'package:flutter/material.dart';
import '../../app/data/models/habit.dart';
import '../values/app_colors.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final DateTime selectedDate;
  final VoidCallback onTap;

  const HabitCard({
    super.key, 
    required this.habit, 
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final colors = AppColors();
    final bool isCompleted = habit.isCompletedOn(selectedDate);
    final String progressText = '${habit.completedCount} / ${habit.durationDays}';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isCompleted || habit.color != null
            ? null
            : colors.blueBlackGradient,
        color: isCompleted ? colors.green : habit.color,
        boxShadow: [
          BoxShadow(
            color: isCompleted
                ? colors.green.withValues(alpha: 0.3)
                : colors.pureBlack.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Habit Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(habit.icon, color: colors.white, size: 18),
          ),
          const SizedBox(width: 12),

          // Habit Name & Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  habit.name,
                  style: TextStyle(
                    color: colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    decorationColor: colors.white.withValues(alpha: 0.7),
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  progressText,
                  style: TextStyle(
                    color: colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Completion Check Button
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? colors.white : Colors.transparent,
              border: Border.all(color: colors.white, width: 1.5),
            ),
            child: isCompleted
                ? Icon(Icons.check, color: colors.green, size: 16)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    ),
  );
  }
}
