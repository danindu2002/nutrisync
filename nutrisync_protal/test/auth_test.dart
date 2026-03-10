import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:NutriSync/screens/login_screen.dart';
import 'package:NutriSync/screens/signup_screen.dart';
import 'package:NutriSync/screens/forgot_password_screen.dart';

// Automated Widget Tests for Authentication
// This file tests common authentication UI behaviors such as:
// 1. Rendering the login screen
// 2. Validation when fields are empty
// 3. Entering username and password
// 4. Remember Me checkbox functionality
// 5. Navigation to Forgot Password screen
// 6. Navigation to Sign Up screen

void main() {

  /// -----------------------------------------------------------
  /// Test 1: Verify Login Screen UI renders correctly
  /// -----------------------------------------------------------
  testWidgets('Login screen renders with required fields',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Check if title exists
        expect(find.text("Login"), findsOneWidget);

        // Check username and password labels
        expect(find.text("Username"), findsOneWidget);
        expect(find.text("Password"), findsOneWidget);

        // Check login button
        expect(find.text("Login"), findsWidgets);

        // Check remember me text
        expect(find.text("Remember Me"), findsOneWidget);
      });


  /// -----------------------------------------------------------
  /// Test 2: Validate empty login submission
  /// -----------------------------------------------------------
  testWidgets('Shows validation error when fields are empty',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap login button without entering credentials
        await tester.tap(find.text('Login'));
        await tester.pump();

        // Expect validation message
        expect(find.text('Please enter username and password'), findsOneWidget);
      });


  /// -----------------------------------------------------------
  /// Test 3: Enter username and password fields
  /// -----------------------------------------------------------
  testWidgets('User can type username and password',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Enter username
        await tester.enterText(
          find.byIcon(Icons.email_outlined),
          "testuser",
        );

        // Enter password
        await tester.enterText(
          find.byIcon(Icons.lock_outline),
          "password123",
        );

        await tester.pump();

        // Verify entered text exists
        expect(find.text("testuser"), findsOneWidget);
        expect(find.text("password123"), findsOneWidget);
      });


  /// -----------------------------------------------------------
  /// Test 4: Remember Me checkbox toggle
  /// -----------------------------------------------------------
  testWidgets('Remember Me checkbox toggles correctly',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        final checkboxFinder = find.byType(Checkbox);

        // Initially unchecked
        Checkbox checkbox = tester.widget(checkboxFinder);
        expect(checkbox.value, false);

        // Tap checkbox
        await tester.tap(checkboxFinder);
        await tester.pump();

        // Should now be checked
        checkbox = tester.widget(checkboxFinder);
        expect(checkbox.value, true);
      });


  /// -----------------------------------------------------------
  /// Test 5: Forgot Password navigation
  /// -----------------------------------------------------------
  testWidgets('Navigates to Forgot Password screen',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap forgot password
        await tester.tap(find.text("Forgot Password?"));
        await tester.pumpAndSettle();

        // Verify navigation
        expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      });


  /// -----------------------------------------------------------
  /// Test 6: Sign Up navigation
  /// -----------------------------------------------------------
  testWidgets('Navigates to Sign Up screen',
          (WidgetTester tester) async {

        await tester.pumpWidget(
          const MaterialApp(
            home: LoginScreen(),
          ),
        );

        // Tap sign up text
        await tester.tap(find.text("Sign up"));
        await tester.pumpAndSettle();

        // Verify navigation
        expect(find.byType(SignUpScreen), findsOneWidget);
      });

}