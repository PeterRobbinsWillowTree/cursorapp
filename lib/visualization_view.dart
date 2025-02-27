import 'package:flutter/material.dart';
import 'package:cursorapp/animated_intercept_view.dart';

class VisualizationView extends StatelessWidget {
  final double? myShipCourse;
  final double? myShipSpeed;
  final double? targetCourse;
  final double? targetSpeed;
  final double? bearing;
  final double? distance;
  final String result;
  final double? interceptCourse;
  final double? interceptSpeed;
  final double? timeToIntercept;

  const VisualizationView({
    super.key,
    required this.myShipCourse,
    required this.myShipSpeed,
    required this.targetCourse,
    required this.targetSpeed,
    required this.bearing,
    required this.distance,
    required this.result,
    required this.interceptCourse,
    required this.interceptSpeed,
    required this.timeToIntercept,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedInterceptView(
      myShipCourse: myShipCourse,
      myShipSpeed: myShipSpeed,
      targetCourse: targetCourse,
      targetSpeed: targetSpeed,
      bearing: bearing,
      distance: distance,
      interceptCourse: interceptCourse,
      interceptSpeed: interceptSpeed,
      timeToIntercept: timeToIntercept,
      result: result,
    );
  }
} 