import 'dart:math';

class InterceptResult {
  final double course;
  final double speed;

  InterceptResult(this.course, this.speed);
}

InterceptResult calculateIntercept({
  required double distance,
  required double bearing,
  required double targetCourse,
  required double targetSpeed,
}) {
  // Validate inputs
  if (distance <= 0) throw ArgumentError('Distance must be positive');
  if (bearing < 0 || bearing >= 360) throw ArgumentError('Bearing must be between 0 and 360');
  if (targetCourse < 0 || targetCourse >= 360) throw ArgumentError('Course must be between 0 and 360');
  if (targetSpeed < 0) throw ArgumentError('Speed must be positive');

  // Convert angles to radians
  final bearingRad = bearing * pi / 180.0;
  final targetCourseRad = targetCourse * pi / 180.0;

  // Target motion vector components
  final targetVx = targetSpeed * sin(targetCourseRad);
  final targetVy = targetSpeed * cos(targetCourseRad);

  // Initial target position (relative to own ship)
  final targetX = distance * sin(bearingRad);
  final targetY = distance * cos(bearingRad);

  // Time to intercept (approximate)
  final timeToIntercept = distance / targetSpeed;

  // Future target position
  final futureX = targetX + (targetVx * timeToIntercept);
  final futureY = targetY + (targetVy * timeToIntercept);

  // Calculate required course and speed
  var interceptCourse = atan2(futureX, futureY) * 180.0 / pi;
  interceptCourse = (interceptCourse + 360) % 360;
  
  final interceptSpeed = sqrt(pow(futureX, 2) + pow(futureY, 2)) / timeToIntercept;

  return InterceptResult(interceptCourse, interceptSpeed);
} 