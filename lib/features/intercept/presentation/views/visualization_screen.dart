import 'package:flutter/material.dart';
import 'dart:math';
import '../../domain/entities/intercept_params.dart';
import '../../domain/entities/intercept_result.dart';

class VisualizationScreen extends StatefulWidget {
  final InterceptResult result;
  final InterceptParams params;

  const VisualizationScreen({
    super.key,
    required this.result,
    required this.params,
  });

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Add listener to check for collision
    _animation.addListener(() {
      if (_checkCollision()) {
        _controller.stop();
      }
    });
    
    _controller.forward();
  }

  bool _checkCollision() {
    if (!mounted) return false;
    
    final painter = InterceptPainter(
      result: widget.result,
      params: widget.params,
      progress: _animation.value,
    );
    
    return painter.areShipsColliding(MediaQuery.of(context).size);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intercept Visualization'),
      ),
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: InterceptPainter(
              result: widget.result,
              params: widget.params,
              progress: _animation.value,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class InterceptPainter extends CustomPainter {
  final InterceptResult result;
  final InterceptParams params;
  final double progress;
  static const double shipLength = 40.0;
  static const double shipWidth = 15.0;
  static const double collisionDistance = shipLength / 2;  // Distance to consider as collision

  InterceptPainter({
    required this.result,
    required this.params,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width < size.height ? size.width : size.height) * 0.45;
    
    // Draw compass rose first (so it's behind everything)
    _drawCompassRose(canvas, center, radius);
    
    // Setup paints
    final myShipPaint = Paint()..color = Colors.blue;
    final targetPaint = Paint()..color = Colors.red;
    final targetPathPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final interceptPathPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Calculate positions
    final bearingRad = (90 - params.bearing!) * pi / 180;
    final scale = size.width / (params.distance! * 3);
    
    final targetInitialPos = center + Offset(
      cos(bearingRad) * params.distance! * scale,
      -sin(bearingRad) * params.distance! * scale,
    );

    final targetCourseRad = (90 - params.targetCourse!) * pi / 180;
    final interceptCourseRad = (90 - result.interceptCourse) * pi / 180;

    // Calculate current positions
    final myShipPos = center + Offset(
      cos(interceptCourseRad) * result.interceptSpeed * progress * scale * 10,
      -sin(interceptCourseRad) * result.interceptSpeed * progress * scale * 10,
    );

    final targetPos = targetInitialPos + Offset(
      cos(targetCourseRad) * params.targetSpeed! * progress * scale * 10,
      -sin(targetCourseRad) * params.targetSpeed! * progress * scale * 10,
    );

    // Draw target's projected path (dotted)
    _drawDottedLine(canvas, targetInitialPos, targetPos, targetPathPaint);
    
    // Draw intercept path (solid)
    canvas.drawLine(center, myShipPos, interceptPathPaint);

    // Draw ships
    _drawShipHull(canvas, center, result.interceptCourse, myShipPaint);
    _drawShipHull(canvas, targetInitialPos, params.targetCourse!, targetPaint);

    // Draw moving ships
    _drawShipHull(canvas, myShipPos, result.interceptCourse, myShipPaint);
    _drawShipHull(canvas, targetPos, params.targetCourse!, targetPaint);

    // Add collision indicator
    if (areShipsColliding(size)) {
      final collisionPaint = Paint()
        ..color = Colors.green.withAlpha(77)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(myShipPos, shipLength, collisionPaint);
    }
  }

  void _drawCompassRose(Canvas canvas, Offset center, double radius) {
    final compassPaint = Paint()
      ..color = Colors.grey.withAlpha(77)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final labelPaint = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw main circle
    canvas.drawCircle(center, radius, compassPaint);

    // Draw cardinal and ordinal points
    for (int i = 0; i < 360; i += 45) {
      final rad = (90 - i) * pi / 180;
      final isCardinal = i % 90 == 0;
      final lineLength = isCardinal ? radius : radius * 0.95;
      
      // Draw lines
      canvas.drawLine(
        center + Offset(cos(rad) * radius * 0.9, -sin(rad) * radius * 0.9),
        center + Offset(cos(rad) * lineLength, -sin(rad) * lineLength),
        compassPaint,
      );

      // Draw labels
      String label;
      switch (i) {
        case 0:
          label = 'N';
          break;
        case 45:
          label = 'NE';
          break;
        case 90:
          label = 'E';
          break;
        case 135:
          label = 'SE';
          break;
        case 180:
          label = 'S';
          break;
        case 225:
          label = 'SW';
          break;
        case 270:
          label = 'W';
          break;
        case 315:
          label = 'NW';
          break;
        default:
          label = '';
      }

      if (label.isNotEmpty) {
        labelPaint.text = TextSpan(
          text: label,
          style: TextStyle(
            color: Colors.grey.withAlpha(179),
            fontSize: isCardinal ? 16 : 14,
            fontWeight: isCardinal ? FontWeight.bold : FontWeight.normal,
          ),
        );
        labelPaint.layout();
        labelPaint.paint(
          canvas,
          center + Offset(
            cos(rad) * (radius + 20) - labelPaint.width / 2,
            -sin(rad) * (radius + 20) - labelPaint.height / 2,
          ),
        );
      }
    }

    // Draw degree marks
    for (int i = 0; i < 360; i += 15) {
      if (i % 45 != 0) {  // Skip where we already drew cardinal/ordinal lines
        final rad = (90 - i) * pi / 180;
        canvas.drawLine(
          center + Offset(cos(rad) * radius * 0.95, -sin(rad) * radius * 0.95),
          center + Offset(cos(rad) * radius, -sin(rad) * radius),
          compassPaint,
        );
      }
    }

    // Draw inner circles
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * i / 3,
        compassPaint,
      );
    }
  }

  void _drawShipHull(Canvas canvas, Offset position, double course, Paint paint) {
    final rad = (90 - course) * pi / 180;
    final path = Path();
    
    // Calculate hull points
    final bow = position + Offset(cos(rad) * shipLength / 2, -sin(rad) * shipLength / 2);
    final stern = position + Offset(-cos(rad) * shipLength / 2, sin(rad) * shipLength / 2);
    final portSide = position + Offset(
      -sin(rad) * shipWidth / 2,
      -cos(rad) * shipWidth / 2,
    );
    final starboardSide = position + Offset(
      sin(rad) * shipWidth / 2,
      cos(rad) * shipWidth / 2,
    );

    // Draw hull shape
    path.moveTo(bow.dx, bow.dy);
    path.lineTo(portSide.dx, portSide.dy);
    path.lineTo(stern.dx, stern.dy);
    path.lineTo(starboardSide.dx, starboardSide.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final count = sqrt(dx * dx + dy * dy) / (dashWidth + dashSpace);
    
    for (var i = 0; i < count; i++) {
      final startFraction = i * (dashWidth + dashSpace) / sqrt(dx * dx + dy * dy);
      final endFraction = (i * (dashWidth + dashSpace) + dashWidth) / sqrt(dx * dx + dy * dy);
      
      canvas.drawLine(
        Offset(
          start.dx + dx * startFraction,
          start.dy + dy * startFraction,
        ),
        Offset(
          start.dx + dx * endFraction,
          start.dy + dy * endFraction,
        ),
        paint,
      );
    }
  }

  bool areShipsColliding(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / (params.distance! * 3);
    
    // Calculate current positions
    final bearingRad = (90 - params.bearing!) * pi / 180;
    final targetInitialPos = center + Offset(
      cos(bearingRad) * params.distance! * scale,
      -sin(bearingRad) * params.distance! * scale,
    );

    final targetCourseRad = (90 - params.targetCourse!) * pi / 180;
    final interceptCourseRad = (90 - result.interceptCourse) * pi / 180;

    final myShipPos = center + Offset(
      cos(interceptCourseRad) * result.interceptSpeed * progress * scale * 10,
      -sin(interceptCourseRad) * result.interceptSpeed * progress * scale * 10,
    );

    final targetPos = targetInitialPos + Offset(
      cos(targetCourseRad) * params.targetSpeed! * progress * scale * 10,
      -sin(targetCourseRad) * params.targetSpeed! * progress * scale * 10,
    );

    // Check if ships are close enough to be considered colliding
    final distance = (myShipPos - targetPos).distance;
    return distance < collisionDistance;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 