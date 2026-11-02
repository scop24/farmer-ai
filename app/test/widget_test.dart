// App-level smoke test: the app boots to the welcome screen.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/app.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('app starts on the welcome screen', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(const ProviderScope(child: KisanSathiApp()));

    expect(find.text('KisanSathi'), findsOneWidget);
    expect(find.text('Choose your language'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
