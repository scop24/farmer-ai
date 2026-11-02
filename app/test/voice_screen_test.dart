import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kisansathi/features/voice/voice_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('voice screen shows chat and suggestion chips', (tester) async {
    await tester.pumpWidget(wrapScreen(const VoiceScreen()));

    expect(find.text('Voice Assistant'), findsOneWidget);
    expect(find.text('Soybean price today?'), findsOneWidget);
    expect(find.text('Tap the mic and speak'), findsOneWidget);
  });

  testWidgets('tapping a suggestion adds a demo reply', (tester) async {
    await tester.pumpWidget(wrapScreen(const VoiceScreen()));

    await tester.tap(find.text('Will it rain this week?'));
    await tester.pumpAndSettle();

    expect(find.textContaining('This is a demo reply'), findsOneWidget);
  });

  testWidgets('mic button honestly reports when voice is unavailable', (
    tester,
  ) async {
    // Simulate a device/browser whose speech engine refuses to start:
    // the screen must say so instead of pretending to listen.
    const channel = MethodChannel('plugin.csdcorp.com/speech_to_text');
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'initialize') return false;
      return null;
    });
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

    await tester.pumpWidget(wrapScreen(const VoiceScreen()));

    await tester.tap(find.byIcon(Icons.mic));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('not available in this browser'),
      findsOneWidget,
    );
  });

  testWidgets('the input box sits below the messages, like a chat app', (
    tester,
  ) async {
    await tester.pumpWidget(wrapScreen(const VoiceScreen()));

    await tester.tap(find.text('Will it rain this week?'));
    await tester.pumpAndSettle();

    final replyY = tester
        .getTopLeft(find.textContaining('This is a demo reply'))
        .dy;
    final inputY = tester.getTopLeft(find.byType(TextField)).dy;
    expect(inputY, greaterThan(replyY));
  });

  testWidgets('a saved conversation is restored when the screen opens', (
    tester,
  ) async {
    // Same storage key and JSON shape as ChatHistoryStore.
    SharedPreferences.setMockInitialValues({
      'voice_chat_history_v1':
          '[{"t":"Saved question from yesterday","u":true},'
          '{"t":"Saved answer from yesterday","u":false}]',
    });

    await tester.pumpWidget(wrapScreen(const VoiceScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Saved question from yesterday'), findsOneWidget);
    expect(find.text('Saved answer from yesterday'), findsOneWidget);
    // The demo seed is replaced by the saved history, not mixed in.
    expect(find.text('What is the soybean price today?'), findsNothing);
  });
}
