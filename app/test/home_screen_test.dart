import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/features/shell/main_shell.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('home shows forecast, chips and prices; chip switches crop', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(wrapScreen(const MainShell()));

    expect(find.text('Namaste, Farmer'), findsOneWidget);
    expect(find.text('Price forecast'), findsOneWidget);
    expect(find.text("Today's prices"), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Soybean'));
    await tester.pumpAndSettle();

    // Forecast header and price row now show the soybean demo price.
    expect(find.textContaining('4,650'), findsWidgets);
  });
}
