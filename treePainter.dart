import 'package:flutter/material.dart';

class OrganicTreePainter extends CustomPainter {
  final double progress; // Expects a value from 0.0 to 1.0

  OrganicTreePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final baseX = size.width / 2;
    final baseY = size.height;

    // The trunk grows to a maximum of 60% of the canvas height
    final maxTrunkHeight = size.height * 0.6;
    final currentTrunkHeight = maxTrunkHeight * progress;

    // Base paint: Stroke gets slightly thicker as the tree grows
    final trunkPaint = Paint()
      ..color = const Color(0xFF00E676)
      ..strokeWidth = 4 + (4 * progress)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 1. The Trunk (Curved instead of straight)
    final trunkPath = Path()..moveTo(baseX, baseY);
    // quadraticBezierTo gives the trunk a slight natural bend
    trunkPath.quadraticBezierTo(
      baseX + 10,
      baseY - (currentTrunkHeight / 2),
      baseX,
      baseY - currentTrunkHeight,
    );
    canvas.drawPath(trunkPath, trunkPaint);

    // 2. First Branch (Sprouts at 30% progress, grows smoothly)
    if (progress > 0.3) {
      // Normalize progress from 0.3 -> 1.0 to a 0.0 -> 1.0 scale
      final branch1Progress = ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
      final startY = baseY - (maxTrunkHeight * 0.35);

      final branchPath = Path()..moveTo(baseX + 3, startY);
      branchPath.quadraticBezierTo(
        baseX - 15,
        startY - 10,
        baseX - (35 * branch1Progress),
        startY - (40 * branch1Progress),
      );

      final branchPaint = Paint()
        ..color = const Color(0xFF00E676)
        ..strokeWidth =
            4 *
            branch1Progress // Thickens as it grows
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(branchPath, branchPaint);
    }

    // 3. Second Branch (Sprouts at 60% progress, grows smoothly)
    if (progress > 0.6) {
      final branch2Progress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);
      final startY = baseY - (maxTrunkHeight * 0.65);

      final branchPath = Path()..moveTo(baseX - 2, startY);
      branchPath.quadraticBezierTo(
        baseX + 15,
        startY - 5,
        baseX + (30 * branch2Progress),
        startY - (35 * branch2Progress),
      );

      final branchPaint = Paint()
        ..color = const Color(0xFF00E676)
        ..strokeWidth = 3 * branch2Progress
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(branchPath, branchPaint);
    }

    // 4. The Crown Glow (Fades and scales in during the last 20%)
    if (progress > 0.8) {
      final crownProgress = ((progress - 0.8) / 0.2).clamp(0.0, 1.0);

      final glowPaint = Paint()
        ..color = const Color(0xFF7CFFB2).withOpacity(0.5 * crownProgress)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(baseX, baseY - currentTrunkHeight),
        35 * crownProgress, // Radius scales up instead of popping in
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant OrganicTreePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
