import 'package:NutriSync/screens/impact_simulator/bmi_results_screen.dart';
import 'package:NutriSync/screens/meal_plan/meal_plan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:NutriSync/screens/impact_simulator/impact_simulation_screen.dart';

// Automated Unit Tests for BMI Results Screen
void main() {

  // Helper function to mount the BmiResultsScreen
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: BmiResultsScreen(),
    );
  }

  /// -----------------------------------------------------------
  /// Test 1: Render BMI Results Screen
  /// -----------------------------------------------------------
  testWidgets('Test 1: Render BMI Results screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify Scaffold exists
    expect(find.byType(Scaffold), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 2: Verify UI elements after loading
  /// -----------------------------------------------------------
  testWidgets('Test 2: Display main UI elements',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();

    // Verify main texts
    expect(find.text('BMI Overview'), findsOneWidget);
    expect(find.text('Analouge Meter'), findsOneWidget);
    expect(find.text('Histogram'), findsOneWidget);

    // Verify category section
    expect(find.text('Category'), findsOneWidget);

    // Verify buttons
    expect(find.text('Impact Simulation'), findsOneWidget);
    expect(find.text('Dive In'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 3: Tab switching functionality
  /// -----------------------------------------------------------
  testWidgets('Test 3: Switch between tabs',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();

    // Tap Histogram tab
    await tester.tap(find.text('Histogram'));
    await tester.pump();

    expect(find.text('Histogram View'), findsOneWidget);

    // Switch back
    await tester.tap(find.text('Analouge Meter'));
    await tester.pump();

    expect(find.text('Category'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 4: Navigate to Impact Simulation screen
  /// -----------------------------------------------------------
  testWidgets('Test 4: Navigation to Impact Simulation screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();

    final impactButton =
        find.widgetWithText(ElevatedButton, 'Impact Simulation');

    await tester.tap(impactButton);
    await tester.pumpAndSettle();

    expect(find.byType(ImpactSimulationScreen), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 5: Navigate to Meal Plan screen
  /// -----------------------------------------------------------
  testWidgets('Test 5: Navigation to Meal Plan screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.pumpAndSettle();

    final diveInButton = find.text('Dive In');
    await tester.tap(diveInButton);
    await tester.pumpAndSettle();

    expect(find.byType(MealPlanScreen), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 6: Render Impact Simulation Screen
  /// -----------------------------------------------------------
  testWidgets('Test 6: Render Impact Simulation screen',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    // Verify Scaffold exists
    expect(find.byType(Scaffold), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 7: Verify AppBar UI elements
  /// -----------------------------------------------------------
  testWidgets('Test 7: Display AppBar elements',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // Check title
    expect(find.text('Impact Simulation'), findsOneWidget);

    // Check back button icon
    expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 8: Loading state shows AI loader
  /// -----------------------------------------------------------
  testWidgets('Test 8: Shows AI loading state initially',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());

    // Initially loading → AI loader should appear
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Check one of loading texts
    expect(find.textContaining('Analyzing'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 9: Verify "Now" section displays BMI
  /// -----------------------------------------------------------
  testWidgets('Test 9: Displays current BMI value',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    // "Now" label
    expect(find.text('Now'), findsOneWidget);

    // BMI label
    expect(find.text('BMI'), findsWidgets);

    // BMI value (25.0)
    expect(find.text('25.0'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 10: Verify "After 6 Months" section
  /// -----------------------------------------------------------
  testWidgets('Test 10: Displays After section',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('After'), findsOneWidget);
    expect(find.text('6 Months'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 11: Verify silhouette widget renders
  /// -----------------------------------------------------------
  testWidgets('Test 11: DynamicBodySilhouette renders',
      (WidgetTester tester) async {

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(DynamicBodySilhouette), findsWidgets);
  });
}