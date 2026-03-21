import 'package:NutriSync/widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:NutriSync/screens/dashboard_screen.dart';

void main() {

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }

  /// -----------------------------------------------------------
  /// Test 1: Render Dashboard Screen
  /// -----------------------------------------------------------
  testWidgets('Test 1: Render Dashboard screen',
          (WidgetTester tester) async {

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(Scaffold), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 2: Display main sections
  /// -----------------------------------------------------------
  testWidgets('Test 2: Display Calories and Nutrition sections',
          (WidgetTester tester) async {

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('Calories'), findsOneWidget);
        expect(find.text('Nutrition'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 3: Display time range tabs
  /// -----------------------------------------------------------
  testWidgets('Test 3: Display range tabs',
          (WidgetTester tester) async {

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.text('1d'), findsOneWidget);
        expect(find.text('1w'), findsOneWidget);
        expect(find.text('1m'), findsOneWidget);
        expect(find.text('1y'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 4: Tap range tab changes selection
  /// -----------------------------------------------------------
  testWidgets('Test 4: Tap 1w tab',
          (WidgetTester tester) async {

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        await tester.tap(find.text('1w'));
        await tester.pump();

        // Just verify tap doesn't crash and UI still exists
        expect(find.text('Calories'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 5: Calories chart loading state
  /// -----------------------------------------------------------
  testWidgets('Test 5: Shows loading indicator initially',
          (WidgetTester tester) async {

        await tester.pumpWidget(createWidgetUnderTest());

        // Since API not mocked → should be loading
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });



}