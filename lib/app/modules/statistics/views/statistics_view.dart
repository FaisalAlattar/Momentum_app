import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/statistics_controller.dart';
import '../../home/views/home_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../../../core/values/app_colors.dart';

class StatisticsView extends GetView<StatisticsController> {
  const StatisticsView({super.key});

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
          'Statistics'.tr,
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
        child: Obx(() {
          final habits = controller.habits;
          if (habits.isEmpty) {
            return Center(
              child: Text(
                'No statistics available yet.'.tr,
                style: TextStyle(
                  color: colors.black.withValues(alpha: 0.6),
                  fontSize: 16,
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final habitColor = habit.color ?? colors.lightBlue;

              return GestureDetector(
                onLongPress: () {
                  HomeView.showDeleteDialog(
                    context,
                    colors,
                    habit.id,
                    Get.find<HomeController>(),
                  );
                },
                child: Container(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon and Name
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: habitColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                habit.icon,
                                color: habitColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                habit.name,
                                style: TextStyle(
                                  color: colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Completion Count
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${habit.completedCount}',
                                style: TextStyle(
                                  color: colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'x',
                                style: TextStyle(
                                  color: colors.black.withValues(alpha: 0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
