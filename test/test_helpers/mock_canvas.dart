import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCanvas extends Fake implements Canvas {
  final List<Offset> points = [];
  final List<Paint> paints = [];
  final List<double> circles = [];

  @override
  void drawCircle(Offset center, double radius, Paint paint) {
    points.add(center);
    circles.add(radius);
    paints.add(paint);
  }

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    points.add(p1);
    points.add(p2);
    paints.add(paint);
  }
} 