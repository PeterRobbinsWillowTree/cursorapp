import 'dart:math';
import '../../domain/entities/intercept_params.dart';
import '../../domain/entities/intercept_result.dart';
import '../../domain/repositories/intercept_repository.dart';

class InterceptRepositoryImpl implements InterceptRepository {
  @override
  Future<InterceptResult> calculateIntercept(InterceptParams params) async {
    if (params.distance == null || params.bearing == null || 
        params.targetCourse == null || params.targetSpeed == null) {
      throw Exception('Missing required parameters');
    }

    // Convert angles to radians
    final bearingRad = params.bearing! * pi / 180.0;
    final targetCourseRad = params.targetCourse! * pi / 180.0;

    // Target motion vector components
    final targetVx = params.targetSpeed! * sin(targetCourseRad);
    final targetVy = params.targetSpeed! * cos(targetCourseRad);

    // Initial target position
    final targetX = params.distance! * sin(bearingRad);
    final targetY = params.distance! * cos(bearingRad);

    // Time to intercept (approximate)
    final timeToIntercept = params.distance! / params.targetSpeed!;

    // Future target position
    final futureX = targetX + (targetVx * timeToIntercept);
    final futureY = targetY + (targetVy * timeToIntercept);

    // Calculate required course and speed
    double interceptCourse = atan2(futureX, futureY) * 180.0 / pi;
    interceptCourse = (interceptCourse + 360) % 360;
    
    final interceptSpeed = sqrt(pow(futureX, 2) + pow(futureY, 2)) / timeToIntercept;

    return InterceptResult(
      interceptCourse: interceptCourse,
      interceptSpeed: interceptSpeed,
      timeToIntercept: (params.distance! / interceptSpeed) * 60, // Convert to minutes
    );
  }
} 