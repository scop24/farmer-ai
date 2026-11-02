import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/features/prices/prices_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('prices list renders and search filters it', (tester) async {
    await tester.pumpWidget(wrapScreen(const PricesScreen()));

    expect(find.text('Crop Prices'), findsOneWidget);
    expect(find.text('Tomato'), findsOneWidget);
    expect(find.text('Wheat'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'onion');
    await tester.pump();

    expect(find.text('Onion'), findsOneWidget);
    expect(find.text('Tomato'), findsNothing);
  });
}
