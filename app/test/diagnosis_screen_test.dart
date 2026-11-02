import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/core/app_strings.dart';
import 'package:kisansathi/core/demo_data.dart';
import 'package:kisansathi/features/diagnosis/diagnosis_screen.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('standard diagnosis shows treatment and the expert note', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(
      wrapScreen(const DiagnosisScreen(diagnosis: demoDiagnosisStandard)),
    );

    expect(find.text('Leaf blight'), findsOneWidget);
    expect(find.text('82%'), findsOneWidget);
    expect(find.textContaining('Remove badly affected leaves'), findsOneWidget);
    // The expert note must always be there, word for word.
    expect(find.text(AppStrings.expertNote), findsOneWidget);
  });

  testWidgets('low-confidence diagnosis shows NO treatment, still shows note', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(
      wrapScreen(const DiagnosisScreen(diagnosis: demoDiagnosisLow)),
    );

    expect(find.text('Result is uncertain'), findsOneWidget);
    expect(find.text('45%'), findsOneWidget);
    expect(find.text('What you can do'), findsNothing);
    expect(find.textContaining('Remove badly affected leaves'), findsNothing);
    expect(find.textContaining('Krishi Vigyan Kendra'), findsOneWidget);
    expect(find.text(AppStrings.expertNote), findsOneWidget);
  });
}
