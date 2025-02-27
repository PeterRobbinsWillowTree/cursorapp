// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:cursorapp/main.dart';
import 'dart:io';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Provide a fake HTTP client
    HttpOverrides.global = null;
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify app title in AppBar
    expect(find.text('Flutter Demo Home Page'), findsOneWidget);

    // Verify counter starts at 0
    expect(find.text('Counter: 0'), findsOneWidget);

    // Verify 'Add' button exists
    expect(find.text('Add'), findsOneWidget);

    // Tap the Add button
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify counter incremented
    expect(find.text('Counter: 1'), findsOneWidget);
  });
}
