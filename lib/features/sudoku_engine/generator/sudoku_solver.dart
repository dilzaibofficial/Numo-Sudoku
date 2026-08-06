import 'dart:math';
import 'dart:typed_data';

import '../domain/grid_spec.dart';

/// Bitmask backtracking solver with a Minimum-Remaining-Values heuristic.
/// One implementation serves solving, uniqueness-checking, and (via
/// [generateFullGrid]) full-grid generation for every supported grid size.
class SudokuSolver {
  SudokuSolver(this.spec)
      : size = spec.size,
        fullMask = (1 << spec.size) - 1;

  final GridSpec spec;
  final int size;
  final int fullMask;

  /// Returns the first solution found for [board], or null if unsolvable.
  /// [board] is not mutated.
  Uint8List? solve(Uint8List board) {
    final state = _SolverState(this, board);
    return state.searchFirst(null) ? state.board : null;
  }

  /// Counts solutions for [board], stopping early once [limit] is reached.
  /// A [limit] of 2 is enough to prove uniqueness (result == 1).
  int countSolutions(Uint8List board, {int limit = 2}) {
    final state = _SolverState(this, board);
    return state.countUpTo(limit);
  }

  /// Generates a random, fully-filled valid grid.
  Uint8List generateFullGrid(Random random) {
    final board = Uint8List(spec.cellCount);
    final state = _SolverState(this, board);
    if (!state.searchFirst(random)) {
      throw StateError('Failed to generate a full grid for $spec');
    }
    return state.board;
  }
}

typedef _MrvCell = ({int row, int col, int candidates});

class _SolverState {
  _SolverState(this.solver, Uint8List initial)
      : board = Uint8List.fromList(initial),
        rowMask = List<int>.filled(solver.size, 0),
        colMask = List<int>.filled(solver.size, 0),
        boxMask = List<int>.filled(solver.size, 0) {
    final size = solver.size;
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        final v = board[r * size + c];
        if (v != 0) _place(r, c, v);
      }
    }
  }

  final SudokuSolver solver;
  final Uint8List board;
  final List<int> rowMask;
  final List<int> colMask;
  final List<int> boxMask;

  int _solutionCount = 0;

  void _place(int row, int col, int value) {
    final bit = 1 << (value - 1);
    board[row * solver.size + col] = value;
    rowMask[row] |= bit;
    colMask[col] |= bit;
    boxMask[solver.spec.boxIndexOf(row, col)] |= bit;
  }

  void _unplace(int row, int col, int value) {
    final bit = 1 << (value - 1);
    board[row * solver.size + col] = 0;
    rowMask[row] &= ~bit;
    colMask[col] &= ~bit;
    boxMask[solver.spec.boxIndexOf(row, col)] &= ~bit;
  }

  _MrvCell? _findMrvCell() {
    final size = solver.size;
    var bestRow = -1, bestCol = -1, bestCandidates = 0, bestCount = 1 << 30;
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (board[r * size + c] != 0) continue;
        final candidates = solver.fullMask &
            ~(rowMask[r] | colMask[c] | boxMask[solver.spec.boxIndexOf(r, c)]);
        final count = _popcount(candidates);
        if (count == 0) return (row: r, col: c, candidates: 0);
        if (count < bestCount) {
          bestCount = count;
          bestRow = r;
          bestCol = c;
          bestCandidates = candidates;
          if (count == 1) break;
        }
      }
    }
    if (bestRow == -1) return null; // board is full
    return (row: bestRow, col: bestCol, candidates: bestCandidates);
  }

  static int _popcount(int mask) {
    var count = 0;
    while (mask != 0) {
      mask &= mask - 1;
      count++;
    }
    return count;
  }

  static List<int> _candidateValues(int mask, Random? random) {
    final values = <int>[];
    var m = mask;
    while (m != 0) {
      final lowBit = m & (-m);
      values.add(lowBit.bitLength);
      m &= m - 1;
    }
    if (random != null) values.shuffle(random);
    return values;
  }

  bool searchFirst(Random? random) {
    final cell = _findMrvCell();
    if (cell == null) return true;
    if (cell.candidates == 0) return false;
    for (final v in _candidateValues(cell.candidates, random)) {
      _place(cell.row, cell.col, v);
      if (searchFirst(random)) return true;
      _unplace(cell.row, cell.col, v);
    }
    return false;
  }

  int countUpTo(int limit) {
    _solutionCount = 0;
    _countRecurse(limit);
    return _solutionCount;
  }

  /// Returns true once [limit] solutions have been found, signalling callers
  /// to stop exploring further branches.
  bool _countRecurse(int limit) {
    final cell = _findMrvCell();
    if (cell == null) {
      _solutionCount++;
      return _solutionCount >= limit;
    }
    if (cell.candidates == 0) return false;
    for (final v in _candidateValues(cell.candidates, null)) {
      _place(cell.row, cell.col, v);
      final stop = _countRecurse(limit);
      _unplace(cell.row, cell.col, v);
      if (stop) return true;
    }
    return false;
  }
}
