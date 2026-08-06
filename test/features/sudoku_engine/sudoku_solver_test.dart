import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_solver.dart';

/// A well-known 9x9 puzzle (0 = blank) with a unique solution.
const _classicPuzzle = [
  5, 3, 0, 0, 7, 0, 0, 0, 0, //
  6, 0, 0, 1, 9, 5, 0, 0, 0, //
  0, 9, 8, 0, 0, 0, 0, 6, 0, //
  8, 0, 0, 0, 6, 0, 0, 0, 3, //
  4, 0, 0, 8, 0, 3, 0, 0, 1, //
  7, 0, 0, 0, 2, 0, 0, 0, 6, //
  0, 6, 0, 0, 0, 0, 2, 8, 0, //
  0, 0, 0, 4, 1, 9, 0, 0, 5, //
  0, 0, 0, 0, 8, 0, 0, 7, 9, //
];

bool _isValidCompleteGrid(GridSpec spec, Uint8List grid) {
  final size = spec.size;
  final fullSet = List<int>.generate(size, (i) => i + 1).toSet();

  for (var r = 0; r < size; r++) {
    final row = {for (var c = 0; c < size; c++) grid[r * size + c]};
    if (row.length != size || !row.containsAll(fullSet)) return false;
  }
  for (var c = 0; c < size; c++) {
    final col = {for (var r = 0; r < size; r++) grid[r * size + c]};
    if (col.length != size || !col.containsAll(fullSet)) return false;
  }
  final boxes = List<Set<int>>.generate(size, (_) => <int>{});
  for (var r = 0; r < size; r++) {
    for (var c = 0; c < size; c++) {
      boxes[spec.boxIndexOf(r, c)].add(grid[r * size + c]);
    }
  }
  for (final box in boxes) {
    if (box.length != size || !box.containsAll(fullSet)) return false;
  }
  return true;
}

void main() {
  group('SudokuSolver.solve', () {
    test('solves a classic 9x9 puzzle to a valid complete grid', () {
      final solver = SudokuSolver(GridSpec.size9);
      final puzzle = Uint8List.fromList(_classicPuzzle);
      final solution = solver.solve(puzzle);

      expect(solution, isNotNull);
      expect(_isValidCompleteGrid(GridSpec.size9, solution!), isTrue);

      // Given cells must be preserved in the solution.
      for (var i = 0; i < puzzle.length; i++) {
        if (puzzle[i] != 0) expect(solution[i], puzzle[i]);
      }
    });

    test('returns null for an unsolvable board', () {
      final solver = SudokuSolver(GridSpec.size9);
      final puzzle = Uint8List.fromList(_classicPuzzle);
      // Force a contradiction: two 5s in the same row.
      puzzle[1] = 5;
      expect(solver.solve(puzzle), isNull);
    });
  });

  group('SudokuSolver.countSolutions', () {
    test('the classic puzzle has exactly one solution', () {
      final solver = SudokuSolver(GridSpec.size9);
      final puzzle = Uint8List.fromList(_classicPuzzle);
      expect(solver.countSolutions(puzzle, limit: 2), 1);
    });

    test('an almost-empty board has multiple solutions (capped at limit)', () {
      final solver = SudokuSolver(GridSpec.size4);
      final puzzle = Uint8List(GridSpec.size4.cellCount); // all blank
      expect(solver.countSolutions(puzzle, limit: 2), 2);
    });
  });

  group('SudokuSolver.generateFullGrid', () {
    test('produces a valid complete grid for every supported size', () {
      final random = Random(42);
      for (final spec in GridSpec.all) {
        final solver = SudokuSolver(spec);
        final grid = solver.generateFullGrid(random);
        expect(grid.length, spec.cellCount);
        expect(_isValidCompleteGrid(spec, grid), isTrue, reason: 'failed for $spec');
      }
    });

    test('is randomized across calls', () {
      final solverA = SudokuSolver(GridSpec.size9);
      final gridA = solverA.generateFullGrid(Random(1));
      final solverB = SudokuSolver(GridSpec.size9);
      final gridB = solverB.generateFullGrid(Random(2));
      expect(gridA, isNot(equals(gridB)));
    });
  });
}
