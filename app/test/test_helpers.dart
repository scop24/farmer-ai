import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/core/theme.dart';

/// Wraps a screen the same way the real app does: Riverpod scope plus
/// the app theme inside a MaterialApp (which also provides navigation).
Widget wrapScreen(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildKisanSathiTheme(), home: child),
  );
}

/// Gives the test a tall phone-like surface so full screens fit
/// without scrolling.
void useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}
