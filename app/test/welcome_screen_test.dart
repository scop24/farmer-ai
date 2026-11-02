import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/features/welcome/welcome_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('welcome shows languages and continues to the shell', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(wrapScreen(const WelcomeScreen()));

    expect(find.text('KisanSathi'), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('हिन्दी'), findsOneWidget);
    expect(find.text('తెలుగు'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'Marathi'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Landed on the main shell with the home dashboard.
    expect(find.text('Namaste, Farmer'), findsOneWidget);
  });
}
