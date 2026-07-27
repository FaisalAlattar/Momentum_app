import 'dart:math';
import 'package:flutter/material.dart';

class StopwatchTimerWidget extends StatelessWidget {
  final int elapsedSeconds;
  final double width;
  final double height;
  final Color ringColor;
  final Color fillColor;
  final Color backgroundColor;
  final double strokeWidth;
  final TextStyle textStyle;

  const StopwatchTimerWidget({
    super.key,
    required this.elapsedSeconds,
    required this.width,
    required this.height,
    required this.ringColor,
    required this.fillColor,
    required this.backgroundColor,
    required this.strokeWidth,
    required this.textStyle,
  });

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;

    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    } else {
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _StopwatchPainter(
          elapsedSeconds: elapsedSeconds,
          ringColor: ringColor,
          fillColor: fillColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Text(
            _formatTime(elapsedSeconds),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _StopwatchPainter extends CustomPainter {
  final int elapsedSeconds;
  final Color ringColor;
  final Color fillColor;
  final Color backgroundColor;
  final double strokeWidth;

  _StopwatchPainter({
    required this.elapsedSeconds,
    required this.ringColor,
    required this.fillColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw ring
    final ringPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, ringPaint);

    // Draw sweep arc
    final sweepPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Completes one full rotation every 60 seconds
    final double progress = (elapsedSeconds % 60) / 60.0;
    // If progress is 0 but time > 0, it means we just hit a full minute. 
    // Usually stopwatches keep sweeping, but at exact 60 it will be 0 length. 
    // To make it look nice, if progress is 0, we can either draw full circle or 0.
    final double sweepAngle = 2 * pi * progress;

    // Start at top (-pi / 2)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _StopwatchPainter oldDelegate) {
    return oldDelegate.elapsedSeconds != elapsedSeconds ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
