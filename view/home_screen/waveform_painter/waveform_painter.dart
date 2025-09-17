import 'package:flutter/material.dart';
import 'dart:ui';

class FakeWaveformPainter extends CustomPainter {
  final List<double> waveData;
  FakeWaveformPainter(this.waveData);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.8) // Soft white with opacity
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0); // Blur effect for smoothness

    final Path path = Path();
    final double widthStep = size.width / waveData.length;
    final double centerY = size.height / 2;

    path.moveTo(0, centerY);

    for (int i = 0; i < waveData.length; i++) {
      double x = i * widthStep;
      double y = centerY - (waveData[i] * centerY * 0.8); // Scale amplitude

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Create a mirror reflection for symmetry (bottom part)
    final Path mirrorPath = Path();
    for (int i = 0; i < waveData.length; i++) {
      double x = i * widthStep;
      double y = centerY + (waveData[i] * centerY * 0.8);

      if (i == 0) {
        mirrorPath.moveTo(x, y);
      } else {
        mirrorPath.lineTo(x, y);
      }
    }

    // Draw mirrored waveform with lower opacity
    canvas.drawPath(mirrorPath, paint..color = Colors.white.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
