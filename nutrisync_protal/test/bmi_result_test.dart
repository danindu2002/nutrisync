import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:NutriSync/screens/bmi_results_screen.dart';
import 'package:NutriSync/screens/impact_simulator/impact_simulation_screen.dart';
import 'package:NutriSync/screens/meal_plan_screen.dart';

void main() {

  /// -----------------------------------------------------------
  /// Test 1: Verify BMI Results Screen renders
  /// -----------------------------------------------------------
  testWidgets('BMI Results screen renders correctly',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: BmiResultsScreen(),
      ),
    );

    // Initially loading → empty screen
    expect(find.byType(Scaffold), findsOneWidget);
  });


  /// -----------------------------------------------------------
  /// Test 2: Check UI after loading completes
  /// -----------------------------------------------------------
  testWidgets('Displays BMI Overview and main UI elements',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: BmiResultsScreen(),
      ),
    );

    // Simulate loading completion
    await tester.pumpAndSettle();

    // Check title
    expect(find.text('BMI Overview'), findsOneWidget);

    // Check tab labels
    expect(find.text('Analouge Meter'), findsOneWidget);
    expect(find.text('Histogram'), findsOneWidget);

    // Check category section
    expect(find.text('Category'), findsOneWidget);

    // Check button
    expect(find.text('Impact Simulation'), findsOneWidget);
  });


  /// -----------------------------------------------------------
  /// Test 3: Tab switching functionality
  /// -----------------------------------------------------------
  testWidgets('Switches between Analogue and Histogram tabs',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: BmiResultsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap Histogram tab
    await tester.tap(find.text('Histogram'));
    await tester.pump();

    // Verify histogram UI appears
    expect(find.text('Histogram View'), findsOneWidget);

    // Switch back to Analogue
    await tester.tap(find.text('Analouge Meter'));
    await tester.pump();

    expect(find.text('Category'), findsOneWidget);
  });


  /// -----------------------------------------------------------
  /// Test 4: Navigate to Impact Simulation screen
  /// -----------------------------------------------------------
  testWidgets('Navigates to Impact Simulation screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: BmiResultsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap button
    await tester.tap(find.text('Impact Simulation'));
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.byType(ImpactSimulationScreen), findsOneWidget);
  });


  /// -----------------------------------------------------------
  /// Test 5: Navigate to Meal Plan screen
  /// -----------------------------------------------------------
  testWidgets('Navigates to Meal Plan screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: BmiResultsScreen(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap "Dive In" button
    await tester.tap(find.text('Dive In'));
    await tester.pumpAndSettle();

    // Verify navigation
    expect(find.byType(MealPlanScreen), findsOneWidget);
  });

}