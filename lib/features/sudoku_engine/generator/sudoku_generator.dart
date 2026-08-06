import 'dart:math';
import 'dart:typed_data';

import '../domain/grid_spec.dart';
import 'sudoku_solver.dart';

class GeneratedPuzzle {
  const GeneratedPuzzle({
    required this.spec,
    required this.puzzle,
    required this.solution,
    required this.clueCount,
  });

  final GridSpec spec;
  final Uint8List puzzle;
  final Uint8List solution;
  final int clueCount;
}

/// Generates puzzles for any [GridSpec] by filling a random full grid and
/// then digging holes while a uniqueness check (via [SudokuSolver]) still
/// passes. A time budget guards against runaway generation on larger grids
/// (16x16) — if the budget expires before the target clue count is reached,
/// the best count found so far is accepted rather than looping indefinitely.
class SudokuGenerator {
  SudokuGenerator(this.spec) : solver = SudokuSolver(spec);

  final GridSpec spec;
  final SudokuSolver solver;

  GeneratedPuzzle generate({
    required Random random,
    required int targetClueCount,
    Duration timeBudget = const Duration(seconds: 2),
  }) {
    final solution = solver.generateFullGrid(random);
    final puzzle = Uint8List.fromList(solution);
    final positions = List<int>.generate(spec.cellCount, (i) => i)
      ..shuffle(random);
    final stopwatch = Stopwatch()..start();
    var clueCount = spec.cellCount;

    for (final pos in positions) {
      if (clueCount <= targetClueCount) break;
      if (stopwatch.elapsed > timeBudget) break;

      final backup = puzzle[pos];
      puzzle[pos] = 0;
      final solutionCount = solver.countSolutions(puzzle, limit: 2);
      if (solutionCount == 1) {
        clueCount--;
      } else {
        puzzle[pos] = backup;
      }
    }

    return GeneratedPuzzle(
      spec: spec,
      puzzle: puzzle,
      solution: solution,
      clueCount: clueCount,
    );
  }
}
