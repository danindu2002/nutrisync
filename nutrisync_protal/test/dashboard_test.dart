import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:NutriSync/screens/dashboard_screen.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

void main() {
  // Helper function to mount the DashboardScreen
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

        // Verify Scaffold exists
        expect(find.byType(Scaffold), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 2: Verify main section headings
  /// -----------------------------------------------------------
  testWidgets('Test 2: Display Calories and Nutrition sections',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Verify section titles are shown
        expect(find.text('Calories'), findsOneWidget);
        expect(find.text('Nutrition'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 3: Verify time range tabs are displayed
  /// -----------------------------------------------------------
  testWidgets('Test 3: Display range tabs',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Verify all chart range filters are present
        expect(find.text('1d'), findsOneWidget);
        expect(find.text('1w'), findsOneWidget);
        expect(find.text('1m'), findsOneWidget);
        expect(find.text('1y'), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 4: Verify tapping a tab does not crash UI
  /// -----------------------------------------------------------
  testWidgets('Test 4: Tap 1w tab',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        // Tap 1w range tab
        await tester.tap(find.text('1w'));
        await tester.pump();

        // Verify screen still renders after interaction
        expect(find.text('Calories'), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 5: Verify loading indicators appear initially
  /// -----------------------------------------------------------
  testWidgets('Test 5: Shows loading indicator initially',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Since chart data loads asynchronously,
        // loading indicators should appear initially
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });


  /// -----------------------------------------------------------
  /// Test 6: Verify nutrition chart loading state
  /// -----------------------------------------------------------
  testWidgets('Test 6: Nutrition chart loading',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Nutrition chart also loads asynchronously,
        // so loading indicator should be visible
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

  /// -----------------------------------------------------------
  /// Test 7: Verify HomeHeader renders
  /// -----------------------------------------------------------
  testWidgets('Test 7: Header renders',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Verify HomeHeader widget is present
        expect(find.byType(HomeHeader), findsOneWidget);
      });

  /// -----------------------------------------------------------
  /// Test 8: Verify scrolling works
  /// -----------------------------------------------------------
  testWidgets('Test 8: Scroll dashboard',
          (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());

        // Perform upward scroll
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, -300),
        );
        await tester.pump();

        // Verify lower content is still reachable after scroll
        expect(find.text('Nutrition'), findsOneWidget);
      });

}