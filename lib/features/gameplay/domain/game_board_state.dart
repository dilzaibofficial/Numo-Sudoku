import 'dart:typed_data';

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

class GameBoardState {
  GameBoardState({
    required this.spec,
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
  }) : undoStack = undoStack ?? const [];

  final GridSpec spec;
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

  static const maxMistakes = 3;

  bool get isGameOver => mistakes >= maxMistakes;
  bool get canUndo => undoStack.isNotEmpty;

  factory GameBoardState.fromPuzzle({
    required GridSpec spec,
    required Uint8List puzzle,
    required Uint8List solution,
  }) {
    return GameBoardState(
      spec: spec,
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
  }) {
    return GameBoardState(
      spec: spec,
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
    );
  }
}
