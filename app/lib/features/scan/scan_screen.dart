import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_strings.dart';
import '../../core/demo_data.dart';
import '../../state/providers.dart';
import '../diagnosis/diagnosis_screen.dart';

/// Screen 4: Scan crop. The camera REALLY captures a leaf photo
/// (on web, through the browser's camera/file capture; on Android,
/// through the camera app) and previews it here. The analysis itself
/// is still a mock until the diagnosis backend is connected.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _picker = ImagePicker();
  Uint8List? _photoBytes;

  Future<void> _takePhoto() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1600,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() => _photoBytes = bytes);
  }

  Future<void> _analyze() async {
    ref.read(scanPhaseProvider.notifier).setPhase(ScanPhase.analyzing);
    // Mock analysis delay for the demo.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    ref.read(scanPhaseProvider.notifier).setPhase(ScanPhase.idle);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DiagnosisScreen(diagnosis: demoDiagnosisStandard),
      ),
    );
  }

  void _openLowConfidenceDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const DiagnosisScreen(diagnosis: demoDiagnosisLow),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final phase = ref.watch(scanPhaseProvider);
    final analyzing = phase == ScanPhase.analyzing;

    const steps = [AppStrings.step1, AppStrings.step2, AppStrings.step3];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(AppStrings.scanTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Semantics(
              label: 'Leaf photo preview',
              child: _photoBytes == null
                  ? Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerLow,
                        border: Border.all(color: scheme.outline),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_camera,
                              size: 56,
                              color: scheme.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.cameraPlaceholder,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.memory(
                        _photoBytes!,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: analyzing ? null : _takePhoto,
              icon: const Icon(Icons.photo_camera),
              label: Text(
                _photoBytes == null
                    ? AppStrings.takePhoto
                    : AppStrings.retakePhoto,
              ),
            ),
            const SizedBox(height: 20),
            Text(AppStrings.scanStepsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            for (var i = 0; i < steps.length; i++)
              ListTile(
                minTileHeight: 52,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: scheme.primary,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                ),
                title: Text(steps[i]),
              ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb_outline, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppStrings.scanTip,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (analyzing) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 12),
              Text(
                AppStrings.analyzing,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: analyzing ? null : _analyze,
              icon: const Icon(Icons.document_scanner),
              label: const Text(AppStrings.analyzeButton),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: analyzing ? null : _openLowConfidenceDemo,
              child: const Text(AppStrings.lowConfidenceDemo),
            ),
          ],
        ),
      ),
    );
  }
}
