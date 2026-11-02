import 'package:flutter/material.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../widgets/demo_badge.dart';

/// Screen 5: Diagnosis result.
///
/// Safety rules built into this screen:
/// - The expert-confirmation note is ALWAYS visible.
/// - When confidence is below 60% the result is shown as uncertain,
///   NO treatment is listed, and the farmer is asked to retake the
///   photo and consult a local expert instead.
class DiagnosisScreen extends StatelessWidget {
  final DemoDiagnosis diagnosis;
  const DiagnosisScreen({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final low = diagnosis.isLowConfidence;
    final percent = (diagnosis.confidence * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.diagnosisTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Align(alignment: Alignment.centerLeft, child: DemoBadge()),
          const SizedBox(height: 16),
          Card(
            color: scheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: low
                        ? Colors.orange.shade100
                        : scheme.primaryContainer,
                    child: Icon(
                      low ? Icons.help_outline : Icons.eco,
                      size: 30,
                      color: low ? Colors.orange.shade800 : scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          low
                              ? AppStrings.uncertainTitle
                              : diagnosis.diseaseName ??
                                    AppStrings.uncertainTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Crop: ${diagnosis.cropName}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: scheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.confidenceLabel,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text('$percent%', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: diagnosis.confidence,
                    minHeight: 10,
                    color: low ? Colors.orange.shade800 : scheme.primary,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!low && diagnosis.treatments.isNotEmpty)
            Card(
              color: scheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.treatmentTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    for (final step in diagnosis.treatments)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (low)
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppStrings.uncertainBody,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Always shown, on every result, without exception.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              border: Border.all(color: scheme.outline),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.expertNote,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(AppStrings.scanAnother),
          ),
        ],
      ),
    );
  }
}
