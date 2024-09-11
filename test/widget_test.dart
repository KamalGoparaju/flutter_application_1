import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Correct the import path to match your actual project name.
import 'package:reminder_app/main.dart'; // Replace 'reminder_app' with your project's package name.

void main() {
  testWidgets('Reminder App Smoke Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(ReminderApp());

    // Verify that the dropdown for day selection is present.
    // Check for the initial value of the dropdown, make sure it matches the initial value set in your app.
    expect(find.text('Monday'), findsOneWidget);
    
    // Verify that the 'Set Reminder' button is present.
    expect(find.widgetWithText(ElevatedButton, 'Set Reminder'), findsOneWidget);
  });
} 
