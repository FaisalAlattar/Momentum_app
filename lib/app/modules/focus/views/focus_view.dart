import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../controllers/focus_controller.dart';
import '../widgets/stopwatch_timer_widget.dart';
import '../../../../core/values/app_colors.dart';

class FocusView extends GetView<FocusController> {
  const FocusView({super.key});

  @override
  Widget build(BuildContext context) {
    // Put controller in memory so it's available when this view is built.
    // Use permanent: true so the countdown survives navigation between tabs.
    Get.put(FocusController(), permanent: true);
    final colors = AppColors();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Focus Time'.tr,
                style: TextStyle(
                  color: colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Stay concentrated and achieve your goals'.tr,
                style: TextStyle(
                  color: colors.black.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              _buildModeSelector(colors, controller),
              const SizedBox(height: 48),
              GetBuilder<FocusController>(
                initState: (_) => controller.syncTimerUI(),
                builder: (_) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.width / 1.5,
                    child: TabBarView(
                      controller: controller.tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        // Pomodoro Tab
                        Center(
                          child: GestureDetector(
                            key: const ValueKey('pomodoro'),
                            onTap: () => _showDurationPicker(context, colors),
                            child: Obx(
                            () => CircularCountDownTimer(
                              key: ValueKey(controller.timerKey.value),
                              // --- TIMER DURATION & CONTROLLER ---
                              duration: controller.duration.value,
                              initialDuration:
                                  controller.initialDurationForUI.value,
                              controller: controller.countDownController,

                              // --- TIMER SIZE & RESPONSIVENESS ---
                              width: MediaQuery.of(context).size.width / 1.8,
                              height: MediaQuery.of(context).size.width / 1.8,

                              // --- RING COLORS & BACKGROUND ---
                              ringColor: colors.surfaceHighlight,
                              fillColor: colors.lightBlue,
                              backgroundColor: colors.surface,

                              // --- STROKE THICKNESS & CAP ---
                              strokeWidth: 15,
                              strokeCap: StrokeCap.round,

                              // --- TEXT TYPOGRAPHY ---
                              textStyle: TextStyle(
                                fontSize: 30,
                                color: colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textFormat: controller.duration.value >= 3600
                                  ? CountdownTextFormat.HH_MM_SS
                                  : CountdownTextFormat.MM_SS,
                              isTimerTextShown: true,

                              // --- ANIMATION & COUNTDOWN BEHAVIOR ---
                              isReverse: true,
                              isReverseAnimation: true,
                              autoStart: controller.isPlaying.value,

                              // --- CALLBACKS ---
                              onStart: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  controller.isPlaying.value = true;
                                });
                              },
                              onComplete: () {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  controller.isPlaying.value = false;
                                  controller.hasStarted.value = false;
                                });
                              },
                            ),
                          ),
                        ),
                        ), // End of Center for Pomodoro
                        // Stopwatch Tab
                        Center(
                          child: Obx(
                            () => StopwatchTimerWidget(
                              key: const ValueKey('stopwatch'),
                            elapsedSeconds:
                                controller.stopwatchElapsedSeconds.value,
                            width: MediaQuery.of(context).size.width / 1.8,
                            height: MediaQuery.of(context).size.width / 1.8,
                            ringColor: colors.surfaceHighlight,
                            fillColor: colors.lightBlue,
                            backgroundColor: colors.surface,
                            strokeWidth: 15,
                            textStyle: TextStyle(
                              fontSize: 38.0,
                              color: colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 64),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildControlBtn(
                      colors: colors,
                      icon: Icons.refresh,
                      onTap: controller.resetTimer,
                    ),
                    const SizedBox(width: 32),
                    _buildMainControlBtn(
                      colors: colors,
                      isPlaying:
                          controller.currentMode.value == FocusMode.pomodoro
                          ? controller.isPlaying.value
                          : controller.isStopwatchPlaying.value,
                      onTap: () {
                        final isPlaying =
                            controller.currentMode.value == FocusMode.pomodoro
                            ? controller.isPlaying.value
                            : controller.isStopwatchPlaying.value;
                        if (isPlaying) {
                          controller.pauseTimer();
                        } else {
                          controller.startOrResumeTimer();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(AppColors colors, FocusController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 48),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceHighlight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: controller.tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: colors.black,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelColor: colors.black.withValues(alpha: 0.5),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        tabs: [
          Tab(text: 'Pomodoro'.tr),
          Tab(text: 'Stopwatch'.tr),
        ],
      ),
    );
  }

  Widget _buildControlBtn({
    required AppColors colors,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Size of the secondary control button (e.g., Reset)
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          // Background color of the button
          color: colors.surface,
          shape: BoxShape.circle,
          // Subtle drop shadow for depth
          boxShadow: [
            BoxShadow(
              color: colors.pureBlack.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // Icon color and size inside the button
        child: Icon(icon, color: colors.black, size: 22),
      ),
    );
  }

  Widget _buildMainControlBtn({
    required AppColors colors,
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Size of the primary action button (Start/Pause)
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          // Gradient background for prominent primary action
          gradient: colors.blueBlackGradient,
          shape: BoxShape.circle,
          // Glowing shadow effect matching the brand colors
          boxShadow: [
            BoxShadow(
              color: colors.lightBlue.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        // Toggle icon (Play or Pause) based on state
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: colors.white,
          size: 32,
        ),
      ),
    );
  }

  void _showDurationPicker(BuildContext context, AppColors colors) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colors.pureBlack.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Duration'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ...[15, 25, 45, 60, 90].map((minutes) {
                          return Obx(() {
                            final isSelected =
                                controller.duration.value == minutes * 60;
                            return GestureDetector(
                              onTap: () {
                                controller.setDuration(minutes);
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colors.lightBlue
                                      : colors.surfaceHighlight,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? colors.lightBlue
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '$minutes ${'Minutes'.tr}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? colors.white
                                          : colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                        }),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            _showCustomDurationDialog(context, colors);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surfaceHighlight,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Custom'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomDurationDialog(BuildContext context, AppColors colors) {
    int selectedMinutes = 30; // Default selection

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: FadeTransition(
            opacity: animation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colors.pureBlack.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Custom Duration'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 80,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMinutes - 1,
                            ),
                            onSelectedItemChanged: (index) {
                              selectedMinutes = index + 1;
                            },
                            children: List.generate(180, (index) {
                              final mins = index + 1;
                              return Center(
                                child: Text(
                                  '$mins',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'mins'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            color: colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: colors.surfaceHighlight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Cancel'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.setDuration(selectedMinutes);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: colors.lightBlue,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.lightBlue.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  'Confirm'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors.white,
                                  ),
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
            ),
          ),
        );
      },
    );
  }
}
