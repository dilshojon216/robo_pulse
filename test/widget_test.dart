// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:robo_pulse/main.dart';
import 'package:robo_pulse/services/settings_service.dart';

void main() {
  testWidgets('RoboPulse app smoke test', (WidgetTester tester) async {
    // Initialize settings service
    final settingsService = SettingsService();
    await settingsService.initialize();

    // Build our app and trigger a frame.
    await tester.pumpWidget(RoboPulseApp(settingsService: settingsService));

    // Verify that our app loads with RoboPulse title
    expect(find.text('RoboPulse'), findsOneWidget);

    // Verify tabs are present
    expect(find.text('Boshqaruv'), findsOneWidget);
    expect(find.text('Kamera'), findsOneWidget);
    expect(find.text('Sozlamalar'), findsOneWidget);
  });
}
