import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:numo_sudoku/features/home/presentation/new_game_screen.dart';

void main() {
  Widget wrap(Widget child) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => child),
        GoRoute(path: '/play', builder: (context, state) => const Scaffold(body: Text('Play'))),
      ],
    );
    return MaterialApp.router(routerConfig: router);
  }

  testWidgets('defaults to 9x9 Classic and Normal difficulty', (tester) async {
    await tester.pumpWidget(wrap(const NewGameScreen()));

    final sizeChip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('9×9 (Classic)'), matching: find.byType(ChoiceChip)),
    );
    expect(sizeChip.selected, isTrue);

    final difficultyChip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('Normal'), matching: find.byType(ChoiceChip)),
    );
    expect(difficultyChip.selected, isTrue);
  });

  testWidgets('tapping a different size/difficulty updates the selection', (tester) async {
    await tester.pumpWidget(wrap(const NewGameScreen()));

    await tester.tap(find.text('16×16'));
    await tester.pump();
    await tester.tap(find.text('Expert'));
    await tester.pump();

    final sizeChip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('16×16'), matching: find.byType(ChoiceChip)),
    );
    final oldSizeChip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('9×9 (Classic)'), matching: find.byType(ChoiceChip)),
    );
    final difficultyChip = tester.widget<ChoiceChip>(
      find.ancestor(of: find.text('Expert'), matching: find.byType(ChoiceChip)),
    );

    expect(sizeChip.selected, isTrue);
    expect(oldSizeChip.selected, isFalse);
    expect(difficultyChip.selected, isTrue);
  });

  testWidgets('Start navigates to the play route', (tester) async {
    await tester.pumpWidget(wrap(const NewGameScreen()));

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('Play'), findsOneWidget);
  });
}
