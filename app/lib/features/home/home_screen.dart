import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../state/providers.dart';
import '../../widgets/demo_badge.dart';

/// Screen 2: Home dashboard with mock forecast chart, crop chips,
/// today's prices and quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedCrop = ref.watch(selectedCropProvider);
    final forecast = demoForecast[selectedCrop] ?? const <double>[];
    final selectedPrice = demoCropPrices.firstWhere(
      (p) => p.crop == selectedCrop,
      orElse: () => demoCropPrices.first,
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.greeting,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.greetingSub,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const DemoBadge(),
              ],
            ),
            const SizedBox(height: 20),
            Text(AppStrings.forecastTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final crop in demoChipCrops)
                  ChoiceChip(
                    label: Text(crop),
                    selected: selectedCrop == crop,
                    onSelected: (_) =>
                        ref.read(selectedCropProvider.notifier).select(crop),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              color: scheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$selectedCrop — ₹${formatRupees(selectedPrice.pricePerQuintal)} ${AppStrings.perQuintal}',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 170,
                      child: LineChart(
                        LineChartData(
                          lineTouchData: const LineTouchData(enabled: false),
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                for (var i = 0; i < forecast.length; i++)
                                  FlSpot(i.toDouble(), forecast[i]),
                              ],
                              isCurved: true,
                              color: scheme.primary,
                              barWidth: 3,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: scheme.primary.withValues(alpha: 0.15),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final day in [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ])
                          Text(day, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(AppStrings.todaysPrices, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final price in demoCropPrices.take(4))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Card(
                  color: scheme.surfaceContainerLow,
                  child: ListTile(
                    minTileHeight: 56,
                    leading: const Icon(Icons.grass),
                    title: Text(price.crop),
                    subtitle: Text(price.mandi),
                    trailing: Text(
                      '₹${formatRupees(price.pricePerQuintal)}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(AppStrings.quickActions, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    icon: Icons.document_scanner,
                    label: AppStrings.actionScan,
                    onTap: () => ref.read(navIndexProvider.notifier).goTo(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.currency_rupee,
                    label: AppStrings.actionPrices,
                    onTap: () => ref.read(navIndexProvider.notifier).goTo(1),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickAction(
                    icon: Icons.mic,
                    label: AppStrings.actionVoice,
                    onTap: () => ref.read(navIndexProvider.notifier).goTo(3),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.55),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 28, color: scheme.primary),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
