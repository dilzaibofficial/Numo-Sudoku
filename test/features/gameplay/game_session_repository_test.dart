import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/gameplay/data/game_session_repository.dart';
import 'package:numo_sudoku/features/gameplay/domain/game_board_state.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/app_database.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_generator.dart';
import 'dart:math';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  group('GameSessionRepository', () {
    late AppDatabase db;
    late GameSessionRepository repository;

    setUp(() {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
      repository = GameSessionRepository(db);
    });

    tearDown(() => db.close());

    test('load returns null when nothing has been saved', () async {
      expect(await repository.load(), isNull);
    });

    test('save then load round-trips a partially-played board exactly', () async {
      final generator = SudokuGenerator(GridSpec.size9);
      final generated = generator.generate(random: Random(5), targetClueCount: 40);
      var state = GameBoardState.fromPuzzle(
        spec: GridSpec.size9,
        puzzle: generated.puzzle,
        solution: generated.solution,
      );

      // Simulate some progress: fill one cell, add a note to another,
      // select a cell, record a mistake and elapsed time.
      final emptyIndex = state.values.indexWhere((v) => v == 0);
      state.values[emptyIndex] = state.solution[emptyIndex];
      final secondEmpty =
          state.values.indexWhere((v) => v == 0, emptyIndex + 1);
      state.notes[secondEmpty].addAll({2, 5});
      state = state.copyWith(
        selectedRow: secondEmpty ~/ 9,
        selectedCol: secondEmpty % 9,
        mistakes: 1,
        elapsed: const Duration(minutes: 3, seconds: 12),
      );

      await repository.save(state);
      final loaded = await repository.load();

      expect(loaded, isNotNull);
      expect(loaded!.spec.size, 9);
      expect(loaded.values, state.values);
      expect(loaded.givens, state.givens);
      expect(loaded.solution, state.solution);
      expect(loaded.notes[secondEmpty], {2, 5});
      expect(loaded.selectedRow, secondEmpty ~/ 9);
      expect(loaded.selectedCol, secondEmpty % 9);
      expect(loaded.mistakes, 1);
      expect(loaded.elapsed, const Duration(minutes: 3, seconds: 12));
    });

    test('clear removes the saved game', () async {
      final generator = SudokuGenerator(GridSpec.size4);
      final generated = generator.generate(random: Random(6), targetClueCount: 11);
      final state = GameBoardState.fromPuzzle(
        spec: GridSpec.size4,
        puzzle: generated.puzzle,
        solution: generated.solution,
      );

      await repository.save(state);
      expect(await repository.load(), isNotNull);

      await repository.clear();
      expect(await repository.load(), isNull);
    });

    test('save overwrites the single in-progress game slot', () async {
      final generatorA = SudokuGenerator(GridSpec.size9);
      final a = generatorA.generate(random: Random(7), targetClueCount: 40);
      final generatorB = SudokuGenerator(GridSpec.size4);
      final b = generatorB.generate(random: Random(8), targetClueCount: 11);

      await repository.save(GameBoardState.fromPuzzle(
        spec: GridSpec.size9,
        puzzle: a.puzzle,
        solution: a.solution,
      ));
      await repository.save(GameBoardState.fromPuzzle(
        spec: GridSpec.size4,
        puzzle: b.puzzle,
        solution: b.solution,
      ));

      final loaded = await repository.load();
      expect(loaded!.spec.size, 4);
    });
  });
}
