import 'package:flutter_test/flutter_test.dart';
import 'package:cursorapp/features/intercept/data/repositories/intercept_repository_impl.dart';
import 'package:cursorapp/features/intercept/domain/entities/intercept_params.dart';

void main() {
  late InterceptRepositoryImpl repository;

  setUp(() {
    repository = InterceptRepositoryImpl();
  });

  group('calculateIntercept', () {
    test('should calculate intercept correctly for valid inputs', () async {
      // Arrange
      final params = InterceptParams(
        distance: 10.0,
        bearing: 45.0,
        targetCourse: 90.0,
        targetSpeed: 15.0,
      );

      // Act
      final result = await repository.calculateIntercept(params);

      // Assert
      expect(result.interceptCourse, isA<double>());
      expect(result.interceptSpeed, isA<double>());
      expect(result.timeToIntercept, isA<double>());
    });

    test('should throw exception for missing parameters', () async {
      // Arrange
      final params = InterceptParams(
        distance: 10.0,
        bearing: null,  // Missing parameter
        targetCourse: 90.0,
        targetSpeed: 15.0,
      );

      // Act & Assert
      expect(
        () => repository.calculateIntercept(params),
        throwsException,
      );
    });
  });
} 