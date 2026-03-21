import 'package:NutriSync/screens/risk_predictor/risk_predictor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Helper function to mount the RiskPredictorScreen
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: RiskPredictorScreen(),
    );
  }

  setUp(() {
    // Mock SharedPreferences with no userId
    SharedPreferences.setMockInitialValues({});
  });

  /// -----------------------------------------------------------
  /// Test 1: Render Risk Predictor Screen
  /// -----------------------------------------------------------
  testWidgets('Test 1: Render Risk Predictor screen',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Verify Scaffold exists
        expect(find.byType(Scaffold), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 2: Verify title and back button
  /// -----------------------------------------------------------
  testWidgets('Test 2: Display title and back button',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Verify screen title
        expect(find.text('Risk Predictor'), findsOneWidget);

        // Verify back icon exists
        expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 3: Verify default dropdown value
  /// -----------------------------------------------------------
  testWidgets('Test 3: Display default selected period',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Verify label text
        expect(find.text('Select Time Period:'), findsOneWidget);

        // Verify default selected value
        expect(find.text('1 year'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 4: Verify Predict Risks button
  /// -----------------------------------------------------------
  testWidgets('Test 4: Display Predict Risks button',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Verify Predict Risks button text
        expect(find.text('Predict Risks'), findsOneWidget);
      });


  /// -----------------------------------------------------------
  /// Test 5: Verify loading state appears initially
  /// -----------------------------------------------------------

  testWidgets('Test 5: Shows loading state initially',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Initially loading indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 6: Verify empty state when no userId exists
  /// -----------------------------------------------------------
  testWidgets('Test 6: Show empty state without userId',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Wait for async methods to complete
        await tester.pumpAndSettle();

        // Verify no data message appears
        expect(find.text('No risks to display for this period.'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 7: Verify dropdown options appear
  /// -----------------------------------------------------------
  testWidgets('Test 7: Open dropdown and show options',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Open dropdown
        await tester.tap(find.text('1 year'));
        await tester.pumpAndSettle();

        // Verify available options
        expect(find.text('2 years'), findsOneWidget);
        expect(find.text('5 years'), findsOneWidget);
        expect(find.text('10 years'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 8: Verify dropdown selection changes
  /// -----------------------------------------------------------
  testWidgets('Test 8: Change selected period',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Open dropdown
        await tester.tap(find.text('1 year'));
        await tester.pumpAndSettle();

        // Select new period
        await tester.tap(find.text('5 years').last);
        await tester.pumpAndSettle();

        // Verify updated selected value
        expect(find.text('5 years'), findsOneWidget);
      });

}