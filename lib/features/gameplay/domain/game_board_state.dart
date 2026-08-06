import 'dart:typed_data';

import '../../sudoku_engine/domain/difficulty.dart';
import '../../sudoku_engine/domain/grid_spec.dart';

class BoardMove {
  const BoardMove({
    required this.cellIndex,
    required this.previousValue,
    required this.previousNotes,
  });

  final int cellIndex;
  final int previousValue;
  final Set<int> previousNotes;
}

/// Points awarded per correctly-self-filled cell, before difficulty
/// scaling. Loosely calibrated against sudoku.com's observed +150 per
/// cell on Easy.
const _basePointsPerCell = {
  PuzzleDifficulty.easy: 150,
  PuzzleDifficulty.normal: 190,
  PuzzleDifficulty.hard: 230,
  PuzzleDifficulty.extraHard: 280,
  PuzzleDifficulty.expert: 350,
};

int pointsPerCellFor(PuzzleDifficulty difficulty) => _basePointsPerCell[difficulty]!;

class GameBoardState {
  GameBoardState({
    required this.spec,
    required this.difficulty,
    required this.givens,
    required this.values,
    required this.solution,
    required this.notes,
    this.selectedRow,
    this.selectedCol,
    this.notesMode = false,
    this.mistakes = 0,
    this.elapsed = Duration.zero,
    this.isComplete = false,
    List<BoardMove>? undoStack,
    Set<int>? hintedCells,
  })  : undoStack = undoStack ?? const [],
        hintedCells = hintedCells ?? const {};

  final GridSpec spec;
  final PuzzleDifficulty difficulty;
  final Uint8List givens;
  final Uint8List values;
  final Uint8List solution;
  final List<Set<int>> notes;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final int mistakes;
  final Duration elapsed;
  final bool isComplete;
  final List<BoardMove> undoStack;
  final Set<int> hintedCells;

  static const maxMistakes = 3;

  bool get isGameOver => mistakes >= maxMistakes;
  bool get canUndo => undoStack.isNotEmpty;

  /// Derived (not stored) so undo/redo can never desync it from the board:
  /// one point bundle per non-given, non-hinted cell that currently holds
  /// its correct value.
  int get score {
    final perCell = pointsPerCellFor(difficulty);
    var correct = 0;
    for (var i = 0; i < values.length; i++) {
      if (givens[i] != 0) continue;
      if (hintedCells.contains(i)) continue;
      if (values[i] != 0 && values[i] == solution[i]) correct++;
    }
    return correct * perCell;
  }

  int get hintsUsed => hintedCells.length;

  factory GameBoardState.fromPuzzle({
    required GridSpec spec,
    required PuzzleDifficulty difficulty,
    required Uint8List puzzle,
    required Uint8List solution,
  }) {
    return GameBoardState(
      spec: spec,
      difficulty: difficulty,
      givens: Uint8List.fromList(puzzle),
      values: Uint8List.fromList(puzzle),
      solution: solution,
      notes: List.generate(spec.cellCount, (_) => <int>{}),
    );
  }

  int cellIndex(int row, int col) => row * spec.size + col;
  bool isGiven(int row, int col) => givens[cellIndex(row, col)] != 0;

  GameBoardState copyWith({
    Uint8List? values,
    List<Set<int>>? notes,
    int? selectedRow,
    int? selectedCol,
    bool? notesMode,
    int? mistakes,
    Duration? elapsed,
    bool? isComplete,
    List<BoardMove>? undoStack,
    Set<int>? hintedCells,
  }) {
    return GameBoardState(
      spec: spec,
      difficulty: difficulty,
      givens: givens,
      solution: solution,
      values: values ?? this.values,
      notes: notes ?? this.notes,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      notesMode: notesMode ?? this.notesMode,
      mistakes: mistakes ?? this.mistakes,
      elapsed: elapsed ?? this.elapsed,
      isComplete: isComplete ?? this.isComplete,
      undoStack: undoStack ?? this.undoStack,
      hintedCells: hintedCells ?? this.hintedCells,
    );
  }
}
