import 'package:go_router/go_router.dart';

import '../../features/gameplay/presentation/gameplay_screen.dart';
import '../../features/home/presentation/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/play',
      builder: (context, state) => const GameplayScreen(),
    ),
  ],
);
