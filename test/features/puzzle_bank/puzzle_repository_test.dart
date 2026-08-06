import 'dart:math';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/app_database.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/puzzle_repository.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/difficulty.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_generator.dart';

void main() {
  group('PuzzleRepository', () {
    late AppDatabase db;
    late PuzzleRepository repository;

    setUp(() {
      db = AppDatabase.withExecutor(NativeDatabase.memory());
      repository = PuzzleRepository(db);
    });

    tearDown(() => db.close());

    test('encodeBoard/decodeBoard round-trips a board including values above 9', () {
      final board = Uint8List.fromList([0, 1, 9, 10, 16, 0]);
      final decoded = decodeBoard(encodeBoard(board));
      expect(decoded, board);
    });

    test('takePuzzle returns null when the bank is empty', () async {
      final result = await repository.takePuzzle(
        spec: GridSpec.size9,
        difficulty: PuzzleDifficulty.easy,
      );
      expect(result, isNull);
    });

    test('a puzzle inserted via addGeneratedPuzzle can be taken exactly once', () async {
      final generator = SudokuGenerator(GridSpec.size9);
      final generated = generator.generate(random: Random(1), targetClueCount: 40);
      await repository.addGeneratedPuzzle(generated);

      final difficulty =
          DifficultyTable.classify(81, generated.clueCount) ?? PuzzleDifficulty.easy;

      final first = await repository.takePuzzle(spec: GridSpec.size9, difficulty: difficulty);
      expect(first, isNotNull);
      expect(first!.solution, generated.solution);

      // Marked used — a second take for the same bucket must find nothing.
      final second = await repository.takePuzzle(spec: GridSpec.size9, difficulty: difficulty);
      expect(second, isNull);
    });

    test('availableCount reflects unused puzzles only', () async {
      final generator = SudokuGenerator(GridSpec.size4);
      final a = generator.generate(random: Random(2), targetClueCount: 11);
      final b = generator.generate(random: Random(3), targetClueCount: 11);
      await repository.addGeneratedPuzzle(a);
      await repository.addGeneratedPuzzle(b);

      final difficulty = DifficultyTable.classify(16, a.clueCount) ?? PuzzleDifficulty.easy;
      final before = await repository.availableCount(spec: GridSpec.size4, difficulty: difficulty);
      expect(before, greaterThanOrEqualTo(1));

      await repository.takePuzzle(spec: GridSpec.size4, difficulty: difficulty);
      final after = await repository.availableCount(spec: GridSpec.size4, difficulty: difficulty);
      expect(after, before - 1);
    });
  });
}
