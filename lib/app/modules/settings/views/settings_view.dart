import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/values/app_colors.dart';
import '../../../routes/app_routes.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context); // Listen to theme changes
    final colors = AppColors();
    return Obx(() {
      final user = controller.authService.firebaseUser.value;

      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Settings'.tr,
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.black.withValues(alpha: 0.1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: user?.photoURL != null
                          ? CachedNetworkImage(
                              imageUrl: user!.photoURL!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.black.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 40,
                                color: colors.black,
                              ),
                            )
                          : Icon(Icons.person, size: 40, color: colors.black),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'Momentum User',
                            style: TextStyle(
                              color: colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (user?.email != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              user!.email!,
                              style: TextStyle(
                                color: colors.black.withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Divider
                Divider(color: colors.border, thickness: 1),
                const SizedBox(height: 32),

                // Settings Options
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildSettingItem(
                        title: 'Profile'.tr,
                        icon: Icons.person_outline,
                        colors: colors,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'General'.tr,
                        icon: Icons.settings_outlined,
                        colors: colors,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'Appearance'.tr,
                        icon: Icons.palette_outlined,
                        colors: colors,
                        onTap: () => Get.toNamed(Routes.appearance),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'Notifications'.tr,
                        icon: Icons.notifications_outlined,
                        colors: colors,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'Statistics'.tr,
                        icon: Icons.bar_chart_outlined,
                        colors: colors,
                        onTap: () => Get.toNamed(Routes.statistics),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'Language'.tr,
                        icon: Icons.language,
                        colors: colors,
                        onTap: () => Get.toNamed(Routes.language),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingItem(
                        title: 'About'.tr,
                        icon: Icons.info_outline,
                        colors: colors,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      // Logout Button
                      _buildSettingItem(
                        title: 'Log out'.tr,
                        icon: Icons.logout_rounded,
                        colors: colors,
                        isDestructive: true,
                        onTap: () => _showLogoutDialog(context, colors),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSettingItem({
    required String title,
    required IconData icon,
    required AppColors colors,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.redAccent : colors.black;
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!isDestructive)
                  Icon(
                    Icons.chevron_right,
                    color: colors.black.withValues(alpha: 0.3),
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppColors colors) {
    showGeneralDialog(
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
                  const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Log out'.tr,
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
                'Are you sure you want to log out of your account?',
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
                        onTap: () => Navigator.pop(context),
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
                        onTap: () async {
                          Navigator.pop(context);
                          await controller.logout();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Log out'.tr,
                            style: const TextStyle(
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
  }
}
