import 'package:go_router/go_router.dart';

import '../../features/gameplay/presentation/gameplay_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/new_game_screen.dart';
import '../../features/sudoku_engine/domain/difficulty.dart';
import '../../features/sudoku_engine/domain/grid_spec.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/new-game',
      builder: (context, state) => const NewGameScreen(),
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) {
        final args = state.extra as NewGameArgs?;
        return GameplayScreen(
          spec: args?.spec ?? GridSpec.size9,
          difficulty: args?.difficulty ?? PuzzleDifficulty.normal,
        );
      },
    ),
  ],
);
