import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_mode_controller.dart';
import 'features/auth/application/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();
  // Guarantees a signed-in (at minimum anonymous) user before the UI ever
  // renders, so gameplay never has to wait on or gate behind auth.
  await container.read(authControllerProvider).ensureSignedIn();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const NumoSudokuApp(),
    ),
  );
}

class NumoSudokuApp extends ConsumerWidget {
  const NumoSudokuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Numo Sudoku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
