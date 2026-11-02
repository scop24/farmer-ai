import 'package:flutter/material.dart';

import 'core/app_strings.dart';
import 'core/theme.dart';
import 'features/welcome/welcome_screen.dart';

class KisanSathiApp extends StatelessWidget {
  const KisanSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: buildKisanSathiTheme(),
      // On a wide screen (desktop browser) the app keeps a phone-like
      // width in the centre, exactly as it was designed and reviewed.
      // On a phone nothing changes.
      builder: (context, child) {
        return ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: child,
            ),
          ),
        );
      },
      home: const WelcomeScreen(),
    );
  }
}
