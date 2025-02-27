import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cursorapp/intercept_visualization.dart';

class AnimatedInterceptVisualization extends InterceptVisualization {
  final double animationValue;
  final double blinkValue;
  final VoidCallback onIntercept;

  AnimatedInterceptVisualization({
    super.myShipCourse,
    super.myShipSpeed,
    super.targetCourse,
    super.targetSpeed,
    super.bearing,
    super.distance,
    super.interceptCourse,
    super.interceptSpeed,
    super.timeToIntercept,
    required this.animationValue,
    required this.blinkValue,
    required this.onIntercept,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 5;

    // Draw background elements from parent
    super.paint(canvas, size);

    // Draw compass and other elements
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw background circle
    paint.color = Colors.grey.withAlpha(77);
    canvas.drawCircle(center, size.width / 3, paint);

    // Draw compass points
    final textStyle = TextStyle(color: Colors.black.withAlpha(128), fontSize: 12);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    ['N', 'E', 'S', 'W'].asMap().forEach((index, point) {
      textPainter.text = TextSpan(text: point, style: textStyle);
      textPainter.layout();
      final angle = index * 90 * pi / 180;
      final radius = size.width / 3 + 20;
      final offset = Offset(
        center.dx + radius * sin(angle) - textPainter.width / 2,
        center.dy - radius * cos(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    });

    // Draw ships and paths
    if (interceptCourse != null && bearing != null && distance != null) {
      final initialTargetPos = Offset(
        center.dx + scale * sin(bearing! * pi / 180),
        center.dy - scale * cos(bearing! * pi / 180),
      );

      // Calculate current positions based on animation value
      final currentTime = timeToIntercept! * animationValue;
      
      // Calculate target's current position
      final targetPos = Offset(
        initialTargetPos.dx + (targetSpeed! * currentTime / 60) * scale * sin(targetCourse! * pi / 180),
        initialTargetPos.dy - (targetSpeed! * currentTime / 60) * scale * cos(targetCourse! * pi / 180),
      );

      // Calculate my ship's position
      final myShipPos = Offset(
        center.dx + (interceptSpeed! * currentTime / 60) * scale * sin(interceptCourse! * pi / 180),
        center.dy - (interceptSpeed! * currentTime / 60) * scale * cos(interceptCourse! * pi / 180),
      );

      // Check if target has crossed our path
      final distanceToPath = distanceToLine(targetPos, center, myShipPos);
      final hasIntercepted = distanceToPath < 5.0;

      if (hasIntercepted) {
        onIntercept();
      }

      // Draw ships at their positions
      if (myShipCourse != null) {
        drawShip(canvas, myShipPos, interceptCourse!, Colors.blue);
      }
      if (targetCourse != null) {
        drawShip(canvas, targetPos, targetCourse!, Colors.red);
      }

      // Draw paths
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      // Draw my ship's current path
      paint.color = Colors.blue.withAlpha(100);
      canvas.drawLine(center, myShipPos, paint);

      // Draw target's current path
      paint.color = Colors.red.withAlpha(100);
      canvas.drawLine(initialTargetPos, targetPos, paint);
    }
  }

  // Helper method to calculate distance from point to line
  double distanceToLine(Offset point, Offset lineStart, Offset lineEnd) {
    if (lineStart == lineEnd) return (point - lineStart).distance;
    
    final numerator = ((lineEnd.dx - lineStart.dx) * (lineStart.dy - point.dy) -
                      (lineStart.dx - point.dx) * (lineEnd.dy - lineStart.dy)).abs();
    final denominator = (lineEnd - lineStart).distance;
    
    return numerator / denominator;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 