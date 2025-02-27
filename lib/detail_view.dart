import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cursorapp/visualization_view.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  double? distance;
  double? bearing;
  double? myShipCourse;
  double? myShipSpeed;
  double? targetCourse;
  double? targetSpeed;
  String? result;

  void computeIntercept() {
    if (distance == null || bearing == null || 
        targetCourse == null || targetSpeed == null) {
      setState(() {
        result = 'Please fill in all fields with valid numbers';
      });
      return;
    }

    try {
      // Convert angles to radians
      double bearingRad = bearing! * pi / 180.0;
      double targetCourseRad = targetCourse! * pi / 180.0;

      // Target motion vector components
      double targetVx = targetSpeed! * sin(targetCourseRad);
      double targetVy = targetSpeed! * cos(targetCourseRad);

      // Initial target position (relative to own ship)
      double targetX = distance! * sin(bearingRad);
      double targetY = distance! * cos(bearingRad);

      // Time to intercept (approximate)
      double timeToIntercept = distance! / targetSpeed!;

      // Future target position
      double futureX = targetX + (targetVx * timeToIntercept);
      double futureY = targetY + (targetVy * timeToIntercept);

      // Calculate required course and speed
      double interceptCourse = atan2(futureX, futureY) * 180.0 / pi;
      interceptCourse = (interceptCourse + 360) % 360;
      
      double interceptSpeed = sqrt(pow(futureX, 2) + pow(futureY, 2)) / timeToIntercept;

      // Time to intercept in minutes
      double timeToInterceptMinutes = (distance! / interceptSpeed) * 60;  // Convert to minutes

      String calculatedResult = 'Required Course: ${interceptCourse.toStringAsFixed(1)}°\n'
               'Required Speed: ${interceptSpeed.toStringAsFixed(1)} knots';

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VisualizationView(
            myShipCourse: myShipCourse,
            myShipSpeed: myShipSpeed,
            targetCourse: targetCourse,
            targetSpeed: targetSpeed,
            bearing: bearing,
            distance: distance,
            interceptCourse: interceptCourse,
            interceptSpeed: interceptSpeed,
            timeToIntercept: timeToInterceptMinutes,
            result: calculatedResult,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        result = 'Error in calculation. Please check input values.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail View'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Distance to Target',
                border: OutlineInputBorder(),
                hintText: 'Enter distance in nautical miles',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => distance = double.tryParse(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Bearing to Target',
                border: OutlineInputBorder(),
                hintText: 'Enter bearing in degrees',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => bearing = double.tryParse(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'My Ship Course',
                border: OutlineInputBorder(),
                hintText: 'Enter my ship course',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => myShipCourse = double.tryParse(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'My Ship Speed',
                border: OutlineInputBorder(),
                hintText: 'Enter my ship speed',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => myShipSpeed = double.tryParse(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Target Course',
                border: OutlineInputBorder(),
                hintText: 'Enter target course',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => targetCourse = double.tryParse(value),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Target Speed',
                border: OutlineInputBorder(),
                hintText: 'Enter target speed',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => targetSpeed = double.tryParse(value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: computeIntercept,
              child: const Text('Compute intercept course and speed'),
            ),
          ],
        ),
      ),
    );
  }
} 