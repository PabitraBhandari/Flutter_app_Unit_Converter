// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/main.dart'; // change if your pubspec "name" differs

void main() {
  testWidgets('renders converter UI', (tester) async {
    // Pump your real app
    await tester.pumpWidget(const UnitConverterApp());
    await tester.pumpAndSettle(); // wait for first frame/layout

    // Title: whichever Text you keyed with ValueKey('app-title')
    expect(find.byKey(const ValueKey('app-title')), findsOneWidget);

    // Core controls present
    expect(find.byType(TextField), findsOneWidget);

    // Find dropdowns (generic-free predicate avoids type parameter issues)
    expect(find.byWidgetPredicate((w) => w is DropdownButton), findsWidgets);
  });
}
