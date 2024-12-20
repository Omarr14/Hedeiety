import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:major_task/main.dart' as app;

Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  group('App Integration Test', () {
    testWidgets('Login and Pledge Gift Flow', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Log in
      final emailField = find.byKey(
          const Key('email_field')); // Assume you added a key for email input
      final passwordField = find.byKey(const Key(
          'password_field')); // Assume you added a key for password input
      final loginButton = find.byKey(
          const Key('login_button')); // Assume you added a key for login button

      await tester.enterText(emailField, 'joe@example.com');
      await tester.enterText(passwordField, '123456789');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Assert we are on the home screen
      expect(find.text('Friends'), findsOneWidget);

      // Tap on a friend
      final friendItem = find.text('Joey'); // Assume "Joey" is a valid contact
      await tester.tap(friendItem);
      await tester.pumpAndSettle();

      // Assert we are on the contact detail screen
      expect(find.text('Birthday Celebration'), findsOneWidget);

      // Pledge a gift for a specific event
      final pledgeButton =
          find.byKey(const Key('pledge_button_Birthday Celebration'));
      await tester.tap(pledgeButton);
      await tester.pumpAndSettle();

      // Assert the gift is pledged
      expect(find.text('Pledged'),
          findsOneWidget); // Adjust based on how you show pledge status
    });
  });
}
