import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_mode_controller.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/profile/data/profile_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();
  // Best-effort, non-blocking: sign in (at minimum anonymous) and sync the
  // profile doc. Must never delay or crash app startup — gameplay is fully
  // local (drift) and has to work with zero network at first launch. If
  // this fails (offline, Firebase unreachable, etc.), sign-in is simply
  // retried the next time something needs it.
  unawaited(_bestEffortSignIn(container));

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const NumoSudokuApp(),
    ),
  );
}

Future<void> _bestEffortSignIn(ProviderContainer container) async {
  try {
    final user = await container.read(authControllerProvider).ensureSignedIn();
    await container.read(profileRepositoryProvider).ensureProfile(user.toProfileInput());
  } catch (_) {
    // No network (or Firebase otherwise unavailable) at startup.
  }
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
