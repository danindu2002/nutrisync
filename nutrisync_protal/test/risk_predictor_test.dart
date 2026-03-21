import 'package:NutriSync/screens/risk_predictor_screen.dart';
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

}