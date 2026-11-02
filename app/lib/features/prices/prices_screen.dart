import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../state/providers.dart';
import '../../widgets/demo_badge.dart';
import '../../widgets/sparkline.dart';

/// Screen 3: Crop prices with search, sparklines and mock pull-to-refresh.
class PricesScreen extends ConsumerWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final query = ref.watch(pricesQueryProvider).toLowerCase();
    final filtered = demoCropPrices
        .where((p) => p.crop.toLowerCase().contains(query))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.pricesTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  const DemoBadge(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: AppStrings.searchHint,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) =>
                    ref.read(pricesQueryProvider.notifier).setQuery(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                AppStrings.updatedToday,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        AppStrings.noPricesMatch,
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : RefreshIndicator(
                      // Mock refresh: waits briefly, data stays the same.
                      onRefresh: () => Future<void>.delayed(
                        const Duration(milliseconds: 800),
                      ),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final price = filtered[index];
                          final up = price.changePercent >= 0;
                          final changeColor = up
                              ? scheme.primary
                              : scheme.error;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Card(
                              color: scheme.surfaceContainerLow,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.grass),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            price.crop,
                                            style: theme.textTheme.titleMedium,
                                          ),
                                          Text(
                                            price.mandi,
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Sparkline(
                                      data: price.spark,
                                      color: changeColor,
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${formatRupees(price.pricePerQuintal)}',
                                          style: theme.textTheme.titleMedium,
                                        ),
                                        Text(
                                          '${up ? '+' : ''}${price.changePercent.toStringAsFixed(1)}%',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: changeColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
