import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../state/providers.dart';
import '../shell/main_shell.dart';

/// Screen 1: Welcome + language choice.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = ref.watch(selectedLanguageProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 16),
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: scheme.primaryContainer,
                child: Icon(Icons.eco, size: 44, color: scheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.welcomeTagline,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            Text(AppStrings.chooseLanguage, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final language in demoLanguages)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  color: selected == language.english
                      ? scheme.primaryContainer.withValues(alpha: 0.55)
                      : scheme.surfaceContainerLow,
                  child: ListTile(
                    minTileHeight: 56,
                    title: Text(language.native),
                    subtitle: Text(language.english),
                    trailing: selected == language.english
                        ? Icon(Icons.check_circle, color: scheme.primary)
                        : const Icon(Icons.circle_outlined),
                    onTap: () => ref
                        .read(selectedLanguageProvider.notifier)
                        .select(language.english),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(builder: (_) => const MainShell()),
                );
              },
              child: const Text(AppStrings.continueLabel),
            ),
          ],
        ),
      ),
    );
  }
}
