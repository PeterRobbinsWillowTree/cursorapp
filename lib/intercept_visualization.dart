import 'package:flutter/material.dart';
import 'dart:math';

class InterceptVisualization extends CustomPainter {
  final double? myShipCourse;
  final double? myShipSpeed;
  final double? targetCourse;
  final double? targetSpeed;
  final double? bearing;
  final double? distance; // in nautical miles
  final double? interceptCourse;
  final double? interceptSpeed;
  final double? timeToIntercept;

  // Scale factor (e.g., 5 pixels per nautical mile)
  final double scale = 0.0;  // Will be set based on size.width / 5

  InterceptVisualization({
    this.myShipCourse,
    this.myShipSpeed,
    this.targetCourse,
    this.targetSpeed,
    this.bearing,
    this.distance,
    this.interceptCourse,
    this.interceptSpeed,
    this.timeToIntercept,
  });

  // Helper method to draw a ship
  void drawShip(Canvas canvas, Offset position, double heading, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;
    paint.color = color;
    
    final shipPath = Path();
    final shipSize = 15.0;  // Increased from 12.0 to 15.0
    
    // Calculate hull points
    final bow = Offset(
      position.dx + shipSize * sin(heading * pi / 180),
      position.dy - shipSize * cos(heading * pi / 180)
    );
    
    // Control points for curved hull
    final portBow = Offset(
      position.dx + shipSize * 0.7 * sin((heading + 30) * pi / 180),
      position.dy - shipSize * 0.7 * cos((heading + 30) * pi / 180)
    );
    
    final starboardBow = Offset(
      position.dx + shipSize * 0.7 * sin((heading - 30) * pi / 180),
      position.dy - shipSize * 0.7 * cos((heading - 30) * pi / 180)
    );
    
    final stern = Offset(
      position.dx - shipSize * 0.5 * sin(heading * pi / 180),
      position.dy + shipSize * 0.5 * cos(heading * pi / 180)
    );
    
    final portStern = Offset(
      position.dx + shipSize * 0.3 * sin((heading + 150) * pi / 180),
      position.dy - shipSize * 0.3 * cos((heading + 150) * pi / 180)
    );
    
    final starboardStern = Offset(
      position.dx + shipSize * 0.3 * sin((heading - 150) * pi / 180),
      position.dy - shipSize * 0.3 * cos((heading - 150) * pi / 180)
    );
    
    // Draw curved hull shape
    shipPath.moveTo(bow.dx, bow.dy);
    shipPath.quadraticBezierTo(portBow.dx, portBow.dy, portStern.dx, portStern.dy);
    shipPath.lineTo(stern.dx, stern.dy);
    shipPath.lineTo(starboardStern.dx, starboardStern.dy);
    shipPath.quadraticBezierTo(starboardBow.dx, starboardBow.dy, bow.dx, bow.dy);
    shipPath.close();
    
    canvas.drawPath(shipPath, paint);
  }

  // Draw time to intercept and input values
  void drawText(Canvas canvas, Size size) {
    // Draw time to intercept only
    if (timeToIntercept != null) {
      final textStyle = TextStyle(color: Colors.green.withAlpha(230), fontSize: 16, fontWeight: FontWeight.bold);
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'Time to intercept: ${timeToIntercept!.toStringAsFixed(1)} minutes',
          style: textStyle,
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      // Draw background
      final paint = Paint()
        ..color = Colors.green.withAlpha(26)  // ~0.1 opacity (26/255)
        ..style = PaintingStyle.fill;
      
      final backgroundRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, 25),
          width: textPainter.width + 20,
          height: textPainter.height + 10,
        ),
        Radius.circular(8),
      );
      canvas.drawRRect(backgroundRect, paint);

      // Center the text
      textPainter.paint(
        canvas,
        Offset(
          (size.width - textPainter.width) / 2,
          20,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 5;  // Changed from 10 to 5
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw background circle
    paint.color = Colors.grey.withAlpha(77);  // ~0.3 opacity (77/255)
    canvas.drawCircle(center, size.width / 3, paint);

    // Draw my ship (blue triangle)
    if (myShipCourse != null) {
      drawShip(canvas, center, myShipCourse!, Colors.blue);
    } else {
      drawShip(canvas, center, 0, Colors.blue);
    }

    // Draw target ship (red triangle) if we have bearing and distance
    if (bearing != null && distance != null) {
      final targetPos = Offset(
        center.dx + scale * sin(bearing! * pi / 180),
        center.dy - scale * cos(bearing! * pi / 180),
      );
      
      if (targetCourse != null) {
        drawShip(canvas, targetPos, targetCourse!, Colors.red);
      } else {
        drawShip(canvas, targetPos, bearing!, Colors.red);
      }

      // Draw line between ships
      paint.color = Colors.grey;
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(center, targetPos, paint);
    }

    // Draw intercept course line if calculated
    if (interceptCourse != null) {
      paint.color = Colors.green;
      paint.strokeWidth = 2;
      canvas.drawLine(
        center,
        Offset(
          center.dx + (size.width / 3) * sin(interceptCourse! * pi / 180),
          center.dy - (size.width / 3) * cos(interceptCourse! * pi / 180),
        ),
        paint,
      );
    }

    // Draw target ship's projected path (dotted line)
    if (targetCourse != null && targetSpeed != null && bearing != null && distance != null) {
      paint.color = Colors.red;
      paint.strokeWidth = 1;
      paint.style = PaintingStyle.stroke;

      final targetScale = size.width / 10; // Use same scale as target position
      final startPoint = Offset(
        center.dx + targetScale * sin(bearing! * pi / 180),
        center.dy - targetScale * cos(bearing! * pi / 180),
      );
      
      final endPoint = Offset(
        startPoint.dx + targetScale * sin(targetCourse! * pi / 180),
        startPoint.dy - targetScale * cos(targetCourse! * pi / 180),
      );

      // Draw dotted line
      final Path path = Path();
      const dashWidth = 5.0;
      const dashSpace = 5.0;
      
      double distance = 0;
      final dx = endPoint.dx - startPoint.dx;
      final dy = endPoint.dy - startPoint.dy;
      final totalDistance = sqrt(dx * dx + dy * dy);
      
      while (distance < totalDistance) {
        path.moveTo(
          startPoint.dx + (dx * distance / totalDistance),
          startPoint.dy + (dy * distance / totalDistance)
        );
        
        distance += dashWidth;
        path.lineTo(
          startPoint.dx + (dx * min(distance, totalDistance) / totalDistance),
          startPoint.dy + (dy * min(distance, totalDistance) / totalDistance)
        );
        
        distance += dashSpace;
      }
      
      canvas.drawPath(path, paint);
    }

    // Draw compass points
    final textStyle = TextStyle(color: Colors.black.withAlpha(128), fontSize: 12);  // ~0.5 opacity
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

    // Draw the text information
    drawText(canvas, size);
  }

  @override
  bool shouldRepaint(InterceptVisualization oldDelegate) => true;
} 