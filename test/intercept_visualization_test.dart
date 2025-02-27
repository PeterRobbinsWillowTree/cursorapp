import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cursorapp/intercept_visualization.dart';
import 'package:cursorapp/detail_view.dart';

void main() {
  group('InterceptVisualization Tests', () {
    testWidgets('Renders basic compass circle and points', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(
              child: CustomPaint(
                key: const Key('visualization'),
                painter: InterceptVisualization(),
                size: const Size(300, 300),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('visualization')), findsOneWidget);
    });

    testWidgets('Shows ships when coordinates provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(
              child: CustomPaint(
                key: const Key('visualization'),
                painter: InterceptVisualization(
                  myShipCourse: 0,
                  myShipSpeed: 10,
                  targetCourse: 90,
                  targetSpeed: 15,
                  bearing: 45,
                  distance: 10,
                ),
                size: const Size(300, 300),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('visualization')), findsOneWidget);
    });

    testWidgets('Shows intercept line when course calculated', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RepaintBoundary(
              child: CustomPaint(
                key: const Key('visualization'),
                painter: InterceptVisualization(
                  myShipCourse: 0,
                  myShipSpeed: 10,
                  targetCourse: 90,
                  targetSpeed: 15,
                  bearing: 45,
                  distance: 10,
                  interceptCourse: 30,
                  interceptSpeed: 12,
                ),
                size: const Size(300, 300),
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('visualization')), findsOneWidget);
    });
  });

  group('Visualization Integration Tests', () {
    testWidgets('Updates visualization after calculation', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: DetailView()));

      // Fill in test values
      await tester.enterText(find.byType(TextField).at(0), '10'); // Distance
      await tester.enterText(find.byType(TextField).at(1), '45'); // Bearing
      await tester.enterText(find.byType(TextField).at(2), '0');  // My Course
      await tester.enterText(find.byType(TextField).at(3), '10'); // My Speed
      await tester.enterText(find.byType(TextField).at(4), '90'); // Target Course
      await tester.enterText(find.byType(TextField).at(5), '15'); // Target Speed

      await tester.tap(find.text('Compute intercept course and speed'));
      await tester.pumpAndSettle();

      // Verify results are displayed
      expect(find.textContaining('Required Course:'), findsOneWidget);
      expect(find.textContaining('Required Speed:'), findsOneWidget);
    });
  });
} 