import 'package:NutriSync/screens/authentication/forgot_password_screen.dart';
import 'package:NutriSync/screens/authentication/login_screen.dart';
import 'package:NutriSync/screens/authentication/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Automated Unit Tests for Authentication
void main() {

  // Helper function to mount the LoginScreen within a MaterialApp
  // so that navigation and material widgets function correctly.
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }

  /// -----------------------------------------------------------
  /// Test 1: Verify Login Screen UI renders correctly
  /// -----------------------------------------------------------
  testWidgets('Test 1: Render the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify main static text elements
    expect(find.text('Login'), findsWidgets); // Might find multiple (title + button)
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember Me'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Verify custom components implicitly via standard widgets inside them
    expect(find.byType(TextField), findsNWidgets(2)); // Username & Password fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
    expect(find.byType(OutlinedButton), findsOneWidget); // Google Sign In
  });

  /// -----------------------------------------------------------
  /// Test 2: Validation when fields are empty
  /// -----------------------------------------------------------
  testWidgets('Test 2: Validation triggers when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the 'Login' elevated button without entering any text
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pump(); // Allow UI to update

    expect(find.text('Please enter username and password'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 3: Entering username and password
  /// -----------------------------------------------------------
  testWidgets('Test 3: Entering text into username and password fields', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Find the text fields
    final textFields = find.byType(TextField);
    final usernameField = textFields.at(0);
    final passwordField = textFields.at(1);

    // Enter text into the fields
    await tester.enterText(usernameField, 'testuser');
    await tester.enterText(passwordField, 'securepassword123');
    await tester.pump();

    // Verify the text was successfully entered
    expect(find.text('testuser'), findsOneWidget);
    expect(find.text('securepassword123'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 4: Remember Me checkbox functionality
  /// -----------------------------------------------------------
  testWidgets('Test 4: Toggle Remember Me checkbox', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Find the Checkbox widget
    final checkboxFinder = find.byType(Checkbox);
    expect(checkboxFinder, findsOneWidget);

    // Verify initial state is false (unchecked)
    Checkbox checkbox = tester.widget(checkboxFinder);
    expect(checkbox.value, isFalse);

    // Tap the checkbox to toggle it
    await tester.tap(checkboxFinder);
    await tester.pump(); // Rebuild widget tree to reflect state change

    // Verify state is now true (checked)
    checkbox = tester.widget(checkboxFinder);
    expect(checkbox.value, isTrue);
  });

  /// -----------------------------------------------------------
  /// Test 5: Navigation to Forgot Password screen
  /// -----------------------------------------------------------
  testWidgets('Test 5: Navigation to Forgot Password screen', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Find and tap the Forgot Password button
    final forgotPasswordText = find.text('Forgot Password?');
    await tester.tap(forgotPasswordText);

    // Wait for the push navigation animation to complete
    await tester.pumpAndSettle();

    // Verify we are on the Forgot Password Screen
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    expect(find.text('Enter the email address you used to register'), findsOneWidget);
  });

  /// -----------------------------------------------------------
  /// Test 6: Navigation to Sign Up screen
  /// -----------------------------------------------------------
  testWidgets('Test 6: Navigation to Sign Up screen', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // The "Sign up" text is wrapped in a GestureDetector inside a WidgetSpan.
    // We can locate the exact Text widget and tap it.
    final signUpText = find.text('Sign up');
    expect(signUpText, findsOneWidget);

    await tester.tap(signUpText);

    // Wait for the push navigation animation to complete
    await tester.pumpAndSettle();

    // Verify we are on the Sign Up Screen
    expect(find.byType(SignUpScreen), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
  });
}