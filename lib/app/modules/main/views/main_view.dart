import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../home/views/home_view.dart';
import '../../settings/views/settings_view.dart';
import '../../../../core/values/app_colors.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Listen to theme changes
    final colors = AppColors();

    return Scaffold(
      backgroundColor: colors.background,
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.02), // Very subtle slide up
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: _getPage(controller.currentIndex.value),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(colors),
      floatingActionButton: Obx(
        () => controller.currentIndex.value == 0
            ? _buildFloatingActionButton(colors)
            : const SizedBox.shrink(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBottomNavigationBar(AppColors colors) {
    return BottomAppBar(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
      shadowColor: colors.pureBlack,
      elevation: 8,
      shape: const CircularNotchedRectangle(),
      notchMargin: 0,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 70,
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: controller.currentIndex.value == 1
                      ? colors.lightBlue
                      : colors.textSecondary,
                  size: 28,
                ),
                onPressed: () => controller.changePage(1),
              ),
              const SizedBox(width: 48), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.home_filled,
                  color: controller.currentIndex.value == 0
                      ? colors.lightBlue
                      : colors.textSecondary,
                  size: 28,
                ),
                onPressed: () => controller.changePage(0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(AppColors colors) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: colors.blueBlackGradient,
        boxShadow: [
          BoxShadow(
            color: colors.lightBlue.withValues(alpha: 0.4),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: controller.onAddHabitPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: Icon(Icons.add, color: colors.pureWhite, size: 32),
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const HomeView(key: ValueKey('HomeView'));
      case 1:
        return const SettingsView(key: ValueKey('SettingsView'));
      default:
        return const HomeView(key: ValueKey('HomeView'));
    }
  }
}
