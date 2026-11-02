import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_strings.dart';
import '../../state/providers.dart';
import '../home/home_screen.dart';
import '../prices/prices_screen.dart';
import '../scan/scan_screen.dart';
import '../voice/voice_screen.dart';

/// App shell with the bottom navigation: Home, Prices, Scan, Voice.
/// The Diagnosis screen is pushed on top of this shell from Scan.
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: const [
          HomeScreen(),
          PricesScreen(),
          ScanScreen(),
          VoiceScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            ref.read(navIndexProvider.notifier).goTo(i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: AppStrings.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.currency_rupee_outlined),
            selectedIcon: Icon(Icons.currency_rupee),
            label: AppStrings.navPrices,
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            selectedIcon: Icon(Icons.document_scanner),
            label: AppStrings.navScan,
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            selectedIcon: Icon(Icons.mic),
            label: AppStrings.navVoice,
          ),
        ],
      ),
    );
  }
}
