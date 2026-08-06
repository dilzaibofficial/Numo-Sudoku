import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/gameplay/application/game_controller.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/app_database.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/puzzle_repository.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/difficulty.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';

void main() {
  // Each test intentionally opens its own isolated in-memory database, which
  // drift's generic heuristic otherwise flags as a possible misuse.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('GameController', () {
    late ProviderContainer container;

    setUp(() {
      // In-memory DB so tests never touch path_provider's platform channel
      // (the bank is empty either way, so startNewGame always falls back
      // to the on-device generator — that fallback path is what's tested).
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('startNewGame populates a board consistent with the difficulty band', () async {
      await container
          .read(gameControllerProvider.notifier)
          .startNewGame(GridSpec.size9, PuzzleDifficulty.easy);

      final state = container.read(gameControllerProvider);
      expect(state, isNotNull);
      expect(state!.values.length, 81);
      expect(state.givens.length, 81);
      expect(state.mistakes, 0);
      expect(state.isComplete, isFalse);

      // Every given must already match the (hidden) solution.
      for (var i = 0; i < 81; i++) {
        if (state.givens[i] != 0) {
          expect(state.values[i], state.solution[i]);
        }
      }
    });

    test('entering the correct value fills the cell without a mistake', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);
      final state = container.read(gameControllerProvider)!;

      final emptyIndex = state.values.indexWhere((v) => v == 0);
      final row = emptyIndex ~/ 9;
      final col = emptyIndex % 9;
      final correctValue = state.solution[emptyIndex];

      controller.selectCell(row, col);
      controller.enterValue(correctValue);

      final updated = container.read(gameControllerProvider)!;
      expect(updated.values[emptyIndex], correctValue);
      expect(updated.mistakes, 0);
    });

    test('entering a wrong value increments the mistake counter', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);
      final state = container.read(gameControllerProvider)!;

      final emptyIndex = state.values.indexWhere((v) => v == 0);
      final row = emptyIndex ~/ 9;
      final col = emptyIndex % 9;
      final wrongValue = (state.solution[emptyIndex] % 9) + 1 == state.solution[emptyIndex]
          ? (state.solution[emptyIndex] % 9) + 2
          : (state.solution[emptyIndex] % 9) + 1;

      controller.selectCell(row, col);
      controller.enterValue(wrongValue);

      final updated = container.read(gameControllerProvider)!;
      expect(updated.values[emptyIndex], wrongValue);
      expect(updated.mistakes, 1);
    });

    test('undo reverts the last move', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);
      final state = container.read(gameControllerProvider)!;

      final emptyIndex = state.values.indexWhere((v) => v == 0);
      controller.selectCell(emptyIndex ~/ 9, emptyIndex % 9);
      controller.enterValue(state.solution[emptyIndex]);
      expect(container.read(gameControllerProvider)!.values[emptyIndex], isNot(0));

      controller.undo();
      final reverted = container.read(gameControllerProvider)!;
      expect(reverted.values[emptyIndex], 0);
      expect(reverted.canUndo, isFalse);
    });

    test('notes mode adds candidates instead of filling the cell', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);
      final state = container.read(gameControllerProvider)!;

      final emptyIndex = state.values.indexWhere((v) => v == 0);
      controller.selectCell(emptyIndex ~/ 9, emptyIndex % 9);
      controller.toggleNotesMode();
      controller.enterValue(5);

      final updated = container.read(gameControllerProvider)!;
      expect(updated.values[emptyIndex], 0);
      expect(updated.notes[emptyIndex], contains(5));
    });

    test('useHint fills the selected cell with the correct value', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);
      final state = container.read(gameControllerProvider)!;

      final emptyIndex = state.values.indexWhere((v) => v == 0);
      controller.selectCell(emptyIndex ~/ 9, emptyIndex % 9);
      controller.useHint();

      final updated = container.read(gameControllerProvider)!;
      expect(updated.values[emptyIndex], updated.solution[emptyIndex]);
    });

    test('three mistakes trigger game over', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size9, PuzzleDifficulty.easy);

      for (var attempt = 0; attempt < 3; attempt++) {
        final state = container.read(gameControllerProvider)!;
        final emptyIndex = state.values.indexWhere((v) => v == 0);
        final row = emptyIndex ~/ 9;
        final col = emptyIndex % 9;
        final wrong = state.solution[emptyIndex] == 9 ? 1 : state.solution[emptyIndex] + 1;
        controller.selectCell(row, col);
        controller.enterValue(wrong);
      }

      final finalState = container.read(gameControllerProvider)!;
      expect(finalState.mistakes, 3);
      expect(finalState.isGameOver, isTrue);
    });

    test('filling every cell with the solution marks the game complete', () async {
      final controller = container.read(gameControllerProvider.notifier);
      await controller.startNewGame(GridSpec.size4, PuzzleDifficulty.easy);
      var state = container.read(gameControllerProvider)!;

      for (var i = 0; i < state.values.length; i++) {
        if (state.values[i] != 0) continue;
        controller.selectCell(i ~/ 4, i % 4);
        controller.enterValue(state.solution[i]);
        state = container.read(gameControllerProvider)!;
      }

      expect(state.isComplete, isTrue);
    });
  });
}
