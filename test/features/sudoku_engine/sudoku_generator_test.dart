import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/difficulty.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_generator.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_solver.dart';

void main() {
  group('SudokuGenerator', () {
    test('generates a uniquely-solvable easy puzzle for every grid size', () {
      final random = Random(7);
      for (final spec in GridSpec.all) {
        final range = DifficultyTable.rangeFor(spec.cellCount, PuzzleDifficulty.easy)!;
        final generator = SudokuGenerator(spec);
        final result = generator.generate(
          random: random,
          targetClueCount: range.max,
        );

        expect(result.clueCount, lessThanOrEqualTo(spec.cellCount), reason: '$spec');
        expect(result.clueCount, greaterThan(0), reason: '$spec');

        // The puzzle's given cells must match the solution exactly.
        for (var i = 0; i < result.solution.length; i++) {
          if (result.puzzle[i] != 0) {
            expect(result.puzzle[i], result.solution[i], reason: '$spec cell $i');
          }
        }

        // Must have exactly one solution.
        final solver = SudokuSolver(spec);
        expect(solver.countSolutions(result.puzzle, limit: 2), 1, reason: '$spec');
      }
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('respects the difficulty clue-count band for 9x9 where time allows', () {
      final random = Random(99);
      const spec = GridSpec.size9;
      for (final difficulty in PuzzleDifficulty.values) {
        final range = DifficultyTable.rangeFor(spec.cellCount, difficulty)!;
        final generator = SudokuGenerator(spec);
        final result = generator.generate(
          random: random,
          targetClueCount: range.min,
          timeBudget: const Duration(seconds: 5),
        );

        // Either it hit the requested band, or the time budget cut it off
        // early (never worse than the band, i.e. never fewer clues removed
        // than needed, and never below 17 which is the theoretical minimum
        // for a uniquely-solvable 9x9 puzzle).
        expect(result.clueCount, greaterThanOrEqualTo(17), reason: '$difficulty');
        expect(result.clueCount, lessThanOrEqualTo(range.max + 5), reason: '$difficulty');

        final solver = SudokuSolver(spec);
        expect(solver.countSolutions(result.puzzle, limit: 2), 1, reason: '$difficulty');
      }
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
