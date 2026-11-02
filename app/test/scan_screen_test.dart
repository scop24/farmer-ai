import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/features/scan/scan_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('scan screen shows placeholder, steps and actions', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(wrapScreen(const ScanScreen()));

    expect(find.text('Your leaf photo will appear here'), findsOneWidget);
    expect(find.text('Take photo'), findsOneWidget);
    expect(
      find.text('Take a clear photo of the affected leaf'),
      findsOneWidget,
    );
    expect(find.text('Analyze leaf photo'), findsOneWidget);
    expect(find.text('Demo: low-confidence result'), findsOneWidget);
  });

  testWidgets('low-confidence demo opens the uncertain result', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(wrapScreen(const ScanScreen()));

    await tester.tap(find.text('Demo: low-confidence result'));
    await tester.pumpAndSettle();

    expect(find.text('Result is uncertain'), findsOneWidget);
    expect(find.textContaining('Remove badly affected leaves'), findsNothing);
  });
}
