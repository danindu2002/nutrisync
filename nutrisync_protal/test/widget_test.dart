import 'package:NutriSync/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NutriSyncApp());

    // Verify that the app builds without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
