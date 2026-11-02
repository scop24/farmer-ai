import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/demo_data.dart';
import 'chat_history_store.dart';

/// The app uses Riverpod as its single state-management approach.
/// Each provider below is a small Notifier with a plain-language job.

class SelectedLanguageNotifier extends Notifier<String> {
  @override
  String build() => 'Hindi';
  void select(String language) => state = language;
}

final selectedLanguageProvider =
    NotifierProvider<SelectedLanguageNotifier, String>(
      SelectedLanguageNotifier.new,
    );

class NavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void goTo(int index) => state = index;
}

final navIndexProvider = NotifierProvider<NavIndexNotifier, int>(
  NavIndexNotifier.new,
);

class SelectedCropNotifier extends Notifier<String> {
  @override
  String build() => 'Wheat';
  void select(String crop) => state = crop;
}

final selectedCropProvider = NotifierProvider<SelectedCropNotifier, String>(
  SelectedCropNotifier.new,
);

class PricesQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void setQuery(String query) => state = query;
}

final pricesQueryProvider = NotifierProvider<PricesQueryNotifier, String>(
  PricesQueryNotifier.new,
);

enum ScanPhase { idle, analyzing }

class ScanPhaseNotifier extends Notifier<ScanPhase> {
  @override
  ScanPhase build() => ScanPhase.idle;
  void setPhase(ScanPhase phase) => state = phase;
}

final scanPhaseProvider = NotifierProvider<ScanPhaseNotifier, ScanPhase>(
  ScanPhaseNotifier.new,
);

class VoiceListeningNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
  void stop() => state = false;
}

final voiceListeningProvider = NotifierProvider<VoiceListeningNotifier, bool>(
  VoiceListeningNotifier.new,
);

class ChatMessagesNotifier extends Notifier<List<DemoChatMessage>> {
  bool _asked = false;
  bool _restoreStarted = false;

  @override
  List<DemoChatMessage> build() => List<DemoChatMessage>.of(demoChatSeed);

  /// Loads the conversation saved on this device, if any. Called
  /// once when the voice screen opens. A saved history never
  /// overwrites a conversation the user has already started in this
  /// session.
  Future<void> restore() async {
    if (_restoreStarted) return;
    _restoreStarted = true;
    final stored = await ChatHistoryStore.load();
    if (stored == null || _asked) return;
    state = stored;
  }

  /// Demo behaviour: the user's message is added together with one
  /// canned demo reply from the assistant. The conversation is then
  /// saved on the device so it survives leaving the app.
  void ask(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _asked = true;
    state = [
      ...state,
      DemoChatMessage(text: trimmed, fromUser: true),
      const DemoChatMessage(text: demoAssistantReply, fromUser: false),
    ];
    ChatHistoryStore.save(state);
  }
}

final chatMessagesProvider =
    NotifierProvider<ChatMessagesNotifier, List<DemoChatMessage>>(
      ChatMessagesNotifier.new,
    );
