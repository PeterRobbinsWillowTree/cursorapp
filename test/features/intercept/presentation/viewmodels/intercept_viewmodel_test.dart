import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cursorapp/features/intercept/domain/entities/intercept_params.dart';
import 'package:cursorapp/features/intercept/domain/entities/intercept_result.dart';
import 'package:cursorapp/features/intercept/domain/usecases/calculate_intercept.dart';
import 'package:cursorapp/features/intercept/presentation/viewmodels/intercept_viewmodel.dart';

class MockCalculateIntercept extends Mock implements CalculateIntercept {}

void main() {
  late InterceptViewModel viewModel;
  late MockCalculateIntercept mockCalculateIntercept;

  setUp(() {
    mockCalculateIntercept = MockCalculateIntercept();
    viewModel = InterceptViewModel(calculateIntercept: mockCalculateIntercept);
  });

  final testParams = InterceptParams(
    distance: 10.0,
    bearing: 45.0,
    targetCourse: 90.0,
    targetSpeed: 15.0,
  );

  final testResult = InterceptResult(
    interceptCourse: 60.0,
    interceptSpeed: 20.0,
    timeToIntercept: 30.0,
  );

  test('initial state is correct', () {
    expect(viewModel.result, isNull);
    expect(viewModel.error, isNull);
    expect(viewModel.isLoading, isFalse);
  });

  group('computeIntercept', () {
    test('should return InterceptResult when successful', () async {
      // Arrange
      when(() => mockCalculateIntercept(testParams))
          .thenAnswer((_) async => testResult);

      // Act
      await viewModel.computeIntercept(testParams);

      // Assert
      expect(viewModel.result, equals(testResult));
      expect(viewModel.error, isNull);
      expect(viewModel.isLoading, isFalse);
      verify(() => mockCalculateIntercept(testParams)).called(1);
    });

    test('should return error when calculation fails', () async {
      // Arrange
      when(() => mockCalculateIntercept(testParams))
          .thenThrow(Exception('Test error'));

      // Act
      await viewModel.computeIntercept(testParams);

      // Assert
      expect(viewModel.result, isNull);
      expect(viewModel.error, contains('Test error'));
      expect(viewModel.isLoading, isFalse);
      verify(() => mockCalculateIntercept(testParams)).called(1);
    });

    test('should show loading state during calculation', () async {
      // Arrange
      when(() => mockCalculateIntercept(testParams))
          .thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return testResult;
          });

      // Act
      final future = viewModel.computeIntercept(testParams);
      
      // Assert loading state
      expect(viewModel.isLoading, isTrue);
      
      // Wait for completion
      await future;
      
      // Assert final state
      expect(viewModel.isLoading, isFalse);
    });
  });
} 