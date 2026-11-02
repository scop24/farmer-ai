import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/demo_data.dart';

/// Saves the voice-assistant chat on this device/browser, so the
/// conversation is still there when the farmer comes back.
///
/// Storage is local only (shared preferences — on web that means
/// this browser's local storage). Every failure — no storage
/// available, old or corrupt data — quietly falls back: loading
/// returns null and the caller uses the demo seed conversation.
/// The chat must never break because saving did.
class ChatHistoryStore {
  static const _key = 'voice_chat_history_v1';

  /// Returns the saved conversation, or null when there is none.
  static Future<List<DemoChatMessage>?> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null) return null;
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      final messages = <DemoChatMessage>[];
      for (final item in decoded) {
        if (item is! Map) return null;
        final text = item['t'];
        final fromUser = item['u'];
        if (text is! String || fromUser is! bool) return null;
        messages.add(DemoChatMessage(text: text, fromUser: fromUser));
      }
      return messages.isEmpty ? null : messages;
    } catch (_) {
      return null;
    }
  }

  /// Best-effort save; errors are ignored on purpose.
  static Future<void> save(List<DemoChatMessage> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode([
        for (final message in messages)
          {'t': message.text, 'u': message.fromUser},
      ]);
      await prefs.setString(_key, encoded);
    } catch (_) {
      // Saving is a bonus; the chat itself keeps working.
    }
  }
}
