import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String? iconAsset;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconAsset,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final colors = AppColors();
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.pureBlack.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: colors.black,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (iconAsset != null)
                    Positioned(
                      left: 20,
                      child: Image.asset(
                        iconAsset!,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                      color: colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
