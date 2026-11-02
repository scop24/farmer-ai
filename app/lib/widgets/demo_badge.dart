import 'package:flutter/material.dart';

import '../core/app_strings.dart';

/// Small chip that clearly marks a screen's data as demo data.
class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(Icons.science_outlined, size: 18, color: scheme.primary),
      label: const Text(AppStrings.demoBadge),
      backgroundColor: scheme.primaryContainer.withValues(alpha: 0.5),
      side: BorderSide.none,
    );
  }
}
