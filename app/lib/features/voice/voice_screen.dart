import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../state/providers.dart';

/// Speech locales per app language (speech recognition uses
/// underscores, text-to-speech uses hyphens).
const _sttLocales = <String, String>{
  'Hindi': 'hi_IN',
  'English': 'en_IN',
  'Marathi': 'mr_IN',
  'Gujarati': 'gu_IN',
  'Punjabi': 'pa_IN',
  'Tamil': 'ta_IN',
  'Telugu': 'te_IN',
};

/// Chat identities used by the chat UI package.
const _farmerId = 'farmer';
const _assistantId = 'kisansathi';

/// Screen 6: Voice assistant.
///
/// The chat itself is rendered by the open-source Flyer Chat package
/// (flutter_chat_ui, Apache 2.0); the messages live in Riverpod as
/// before and are mirrored into the package's controller, and the
/// conversation is saved on the device (see ChatHistoryStore) so it
/// is still there when the farmer returns.
///
/// The microphone REALLY listens: speech recognition runs on the
/// device/browser's built-in speech engine (on web that is the
/// browser's speech recognition, best in Chrome) in the language
/// chosen on the welcome screen, and the assistant's reply is spoken
/// back with the built-in text-to-speech voice. The ANSWERS are still
/// demo answers until the real assistant backend is connected.
class VoiceScreen extends ConsumerStatefulWidget {
  const VoiceScreen({super.key});

  @override
  ConsumerState<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends ConsumerState<VoiceScreen> {
  final _controller = TextEditingController();
  final _speech = SpeechToText();
  final _tts = FlutterTts();
  final _chatController = InMemoryChatController();

  /// The messages currently mirrored into [_chatController], and the
  /// counter that gives every mirrored message a unique id.
  List<DemoChatMessage> _synced = const [];
  int _idCounter = 0;

  bool _speechReady = false;
  String? _voiceStatus;
  String _heardText = '';

  @override
  void initState() {
    super.initState();
    _syncChat(ref.read(chatMessagesProvider));
    // Load any conversation saved on this device; the notifier
    // ignores it if the user has already started asking.
    ref.read(chatMessagesProvider.notifier).restore();
  }

  @override
  void dispose() {
    _controller.dispose();
    _chatController.dispose();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  Message _toChatMessage(DemoChatMessage message, DateTime at) {
    return Message.text(
      id: 'm${_idCounter++}',
      authorId: message.fromUser ? _farmerId : _assistantId,
      createdAt: at,
      text: message.text,
    );
  }

  bool _isAppendOfSynced(List<DemoChatMessage> next) {
    if (next.length < _synced.length) return false;
    for (var i = 0; i < _synced.length; i++) {
      if (next[i].text != _synced[i].text ||
          next[i].fromUser != _synced[i].fromUser) {
        return false;
      }
    }
    return true;
  }

  /// Mirrors the Riverpod conversation into the chat package.
  /// Appends are inserted one by one (with the current time); a
  /// different conversation (first load, restored history) replaces
  /// the list with times staggered backwards so ordering and time
  /// grouping read naturally.
  void _syncChat(List<DemoChatMessage> next) {
    if (_isAppendOfSynced(next)) {
      for (var i = _synced.length; i < next.length; i++) {
        _chatController.insertMessage(_toChatMessage(next[i], DateTime.now()));
      }
    } else {
      final now = DateTime.now();
      _chatController.setMessages([
        for (var i = 0; i < next.length; i++)
          _toChatMessage(
            next[i],
            now.subtract(Duration(minutes: next.length - i)),
          ),
      ]);
    }
    _synced = List.of(next);
  }

  Future<User?> _resolveUser(String id) async {
    return User(id: id, name: id == _assistantId ? 'KisanSathi' : 'You');
  }

  void _send() {
    final text = _controller.text;
    _controller.clear();
    _askAndSpeak(text);
  }

  /// Adds the question to the chat together with the demo reply, and
  /// speaks the reply aloud.
  void _askAndSpeak(String text) {
    if (text.trim().isEmpty) return;
    ref.read(chatMessagesProvider.notifier).ask(text);
    _speak(demoAssistantReply);
  }

  Future<void> _speak(String text) async {
    try {
      final language = ref.read(selectedLanguageProvider);
      final locale = (_sttLocales[language] ?? 'en_IN').replaceAll('_', '-');
      await _tts.setLanguage(locale);
      await _tts.speak(text);
    } catch (_) {
      // Speaking is a bonus; if the browser/device has no voice,
      // the reply is still readable in the chat.
    }
  }

  Future<void> _toggleMic() async {
    final listeningNotifier = ref.read(voiceListeningProvider.notifier);
    if (ref.read(voiceListeningProvider)) {
      await _speech.stop();
      listeningNotifier.stop();
      return;
    }

    if (!_speechReady) {
      var available = false;
      try {
        available = await _speech.initialize(
          onStatus: _onSpeechStatus,
          onError: (_) => _onSpeechError(),
        );
      } catch (_) {
        available = false;
      }
      _speechReady = available;
    }
    if (!_speechReady) {
      setState(() => _voiceStatus = AppStrings.voiceUnavailable);
      return;
    }

    setState(() {
      _voiceStatus = null;
      _heardText = '';
    });
    listeningNotifier.toggle();
    final language = ref.read(selectedLanguageProvider);
    await _speech.listen(
      onResult: _onSpeechResult,
      listenOptions: SpeechListenOptions(
        localeId: _sttLocales[language] ?? 'en_IN',
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() => _heardText = result.recognizedWords);
    if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
      final words = result.recognizedWords;
      ref.read(voiceListeningProvider.notifier).stop();
      _askAndSpeak(words);
    }
  }

  void _onSpeechStatus(String status) {
    if ((status == 'done' || status == 'notListening') && mounted) {
      ref.read(voiceListeningProvider.notifier).stop();
    }
  }

  void _onSpeechError() {
    if (mounted) ref.read(voiceListeningProvider.notifier).stop();
  }

  /// Our own input area, shown below the chat list: the suggestion
  /// chips plus the type-and-send row, in the app's own wording.
  /// (It is NOT placed inside the chat package: the package stacks a
  /// custom composer at the top of its area, which put the input box
  /// above the messages. As a sibling under the chat it sits where a
  /// chat input belongs — at the bottom.)
  Widget _composer(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: [
              for (final suggestion in demoSuggestions)
                ActionChip(
                  label: Text(suggestion),
                  onPressed: () => _askAndSpeak(suggestion),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: AppStrings.typeHint,
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _send,
                icon: const Icon(Icons.send),
                tooltip: 'Send',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final listening = ref.watch(voiceListeningProvider);

    // Mirror every conversation change into the chat package.
    ref.listen(chatMessagesProvider, (previous, next) => _syncChat(next));

    final statusText = listening
        ? (_heardText.isNotEmpty ? _heardText : AppStrings.listening)
        : (_voiceStatus ?? AppStrings.tapMic);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                AppStrings.voiceTitle,
                style: theme.textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                AppStrings.voiceHint,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Chat(
                currentUserId: _farmerId,
                resolveUser: _resolveUser,
                chatController: _chatController,
                // The package's own theme type, recoloured from the
                // app's Material scheme so the chat matches the app.
                theme: ChatTheme.light().copyWith(
                  colors: ChatColors(
                    primary: scheme.primary,
                    onPrimary: scheme.onPrimary,
                    surface: scheme.surface,
                    onSurface: scheme.onSurface,
                    surfaceContainer: scheme.surfaceContainer,
                    surfaceContainerLow: scheme.surfaceContainerLow,
                    surfaceContainerHigh: scheme.surfaceContainerHigh,
                  ),
                ),
                // No composer inside the chat package (see
                // _composer): the message list gets the full area.
                builders: Builders(
                  composerBuilder: (_) => const SizedBox.shrink(),
                ),
              ),
            ),
            _composer(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Microphone button',
                    button: true,
                    child: InkWell(
                      onTap: _toggleMic,
                      borderRadius: BorderRadius.circular(36),
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: listening
                            ? scheme.error
                            : scheme.primary,
                        child: Icon(
                          listening ? Icons.stop : Icons.mic,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(statusText, style: theme.textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
