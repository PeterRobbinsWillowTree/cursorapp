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
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isPlaying = false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _toggleAnimation();
    });
  }

  void _toggleAnimation() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.forward(from: 0);
      } else {
        _controller.stop();
      }
    });
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
        title: const Text('Visualization'),
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleAnimation,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: InterceptPainter(
                    result: widget.result,
                    params: widget.params,
                    progress: _animation.value,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Input Values:'),
                Text('Distance: ${widget.params.distance!.toStringAsFixed(1)} nm'),
                Text('Bearing: ${widget.params.bearing!.toStringAsFixed(1)}°'),
                Text('Target Course: ${widget.params.targetCourse!.toStringAsFixed(1)}°'),
                Text('Target Speed: ${widget.params.targetSpeed!.toStringAsFixed(1)} kts'),
                const SizedBox(height: 8),
                Text('Calculated Results:'),
                Text('Intercept Course: ${widget.result.interceptCourse.toStringAsFixed(1)}°'),
                Text('Intercept Speed: ${widget.result.interceptSpeed.toStringAsFixed(1)} kts'),
                Text('Time to Intercept: ${widget.result.timeToIntercept.toStringAsFixed(1)} hours'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InterceptPainter extends CustomPainter {
  final InterceptResult result;
  final InterceptParams params;
  final double progress;
  static const double shipSize = 20.0;

  InterceptPainter({
    required this.result,
    required this.params,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width < size.height ? size.width : size.height) * 0.45;
    final scale = radius / (params.distance! * 1.2); // Scale based on initial distance
    
    // Setup paints
    final myShipPaint = Paint()..color = Colors.blue;
    final targetPaint = Paint()..color = Colors.red;
    final interceptPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final targetPathPaint = Paint()
      ..color = Colors.red.withAlpha(120)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw compass for reference
    _drawCompass(canvas, size, center, radius);

    // Calculate positions
    final bearingRad = (90 - params.bearing!) * pi / 180;
    final targetInitialPos = center + Offset(
      cos(bearingRad) * params.distance! * scale,
      -sin(bearingRad) * params.distance! * scale,
    );

    // Calculate time-based positions
    final timeToIntercept = result.timeToIntercept / 60; // Convert to hours
    final myShipPos = _calculatePosition(
      center,
      result.interceptCourse,
      result.interceptSpeed,
      progress * timeToIntercept,
      scale
    );
    final targetPos = _calculatePosition(
      targetInitialPos,
      params.targetCourse!,
      params.targetSpeed!,
      progress * timeToIntercept,
      scale
    );

    // Draw target's projected path (dotted)
    _drawDottedLine(canvas, targetInitialPos, targetPos, targetPathPaint);
    
    // Draw intercept line
    canvas.drawLine(center, myShipPos, interceptPaint);

    // Draw ships
    _drawShipHull(canvas, center, result.interceptCourse, myShipPaint);
    _drawShipHull(canvas, targetInitialPos, params.targetCourse!, targetPaint);
    
    // Draw moving ships
    if (progress > 0) {
      _drawShipHull(canvas, myShipPos, result.interceptCourse, myShipPaint);
      _drawShipHull(canvas, targetPos, params.targetCourse!, targetPaint);
    }
  }

  Offset _calculatePosition(Offset start, double course, double speed, double time, double scale) {
    final rad = (90 - course) * pi / 180;
    return start + Offset(
      cos(rad) * speed * time * scale,
      -sin(rad) * speed * time * scale,
    );
  }

  void _drawShipHull(Canvas canvas, Offset pos, double course, Paint paint) {
    final rad = (90 - course) * pi / 180;
    final path = Path();
    
    // Draw a ship-like hull shape
    path.moveTo(
      pos.dx + cos(rad) * shipSize,
      pos.dy - sin(rad) * shipSize
    );
    
    // Bow
    path.lineTo(
      pos.dx + cos(rad + 0.3) * shipSize * 0.5,
      pos.dy - sin(rad + 0.3) * shipSize * 0.5
    );
    path.lineTo(
      pos.dx + cos(rad - 0.3) * shipSize * 0.5,
      pos.dy - sin(rad - 0.3) * shipSize * 0.5
    );
    
    // Stern
    path.lineTo(
      pos.dx - cos(rad) * shipSize,
      pos.dy + sin(rad) * shipSize
    );
    
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

  void _drawCompass(Canvas canvas, Size size, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.grey.withAlpha(100)
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, paint);
    
    for (var i = 0; i < 360; i += 90) {
      final rad = (90 - i) * pi / 180;
      canvas.drawLine(
        center,
        center + Offset(cos(rad) * radius, -sin(rad) * radius),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 