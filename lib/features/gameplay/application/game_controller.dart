import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../puzzle_bank/data/puzzle_repository.dart';
import '../../sudoku_engine/domain/difficulty.dart';
import '../../sudoku_engine/domain/grid_spec.dart';
import '../../sudoku_engine/generator/sudoku_generator.dart';
import '../domain/game_board_state.dart';

class _GenerateParams {
  const _GenerateParams(this.spec, this.targetClueCount, this.seed);
  final GridSpec spec;
  final int targetClueCount;
  final int seed;
}

GeneratedPuzzle _generateInIsolate(_GenerateParams params) {
  final generator = SudokuGenerator(params.spec);
  return generator.generate(
    random: Random(params.seed),
    targetClueCount: params.targetClueCount,
  );
}

class GameController extends Notifier<GameBoardState?> {
  Timer? _ticker;

  @override
  GameBoardState? build() {
    ref.onDispose(() => _ticker?.cancel());
    return null;
  }

  Future<void> startNewGame(GridSpec spec, PuzzleDifficulty difficulty) async {
    _ticker?.cancel();

    final repository = ref.read(puzzleRepositoryProvider);
    final banked = await repository.takePuzzle(spec: spec, difficulty: difficulty);

    final Uint8List puzzle;
    final Uint8List solution;
    if (banked != null) {
      puzzle = banked.puzzle;
      solution = banked.solution;
    } else {
      final range = DifficultyTable.rangeFor(spec.cellCount, difficulty)!;
      final target = (range.min + range.max) ~/ 2;
      final seed = DateTime.now().millisecondsSinceEpoch;
      final generated = await compute(
        _generateInIsolate,
        _GenerateParams(spec, target, seed),
      );
      puzzle = generated.puzzle;
      solution = generated.solution;
    }

    state = GameBoardState.fromPuzzle(spec: spec, puzzle: puzzle, solution: solution);
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current == null || current.isComplete || current.isGameOver) return;
      state = current.copyWith(
        elapsed: current.elapsed + const Duration(seconds: 1),
      );
    });
  }

  void selectCell(int row, int col) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(selectedRow: row, selectedCol: col);
  }

  void toggleNotesMode() {
    final current = state;
    if (current == null) return;
    state = current.copyWith(notesMode: !current.notesMode);
  }

  void enterValue(int value) {
    final current = state;
    if (current == null) return;
    if (current.isGameOver || current.isComplete) return;
    final row = current.selectedRow;
    final col = current.selectedCol;
    if (row == null || col == null) return;
    if (current.isGiven(row, col)) return;

    final index = current.cellIndex(row, col);

    if (current.notesMode) {
      final newNotes = List<Set<int>>.generate(
        current.notes.length,
        (i) => i == index ? {...current.notes[i]} : current.notes[i],
      );
      if (newNotes[index].contains(value)) {
        newNotes[index].remove(value);
      } else {
        newNotes[index].add(value);
      }
      state = current.copyWith(notes: newNotes);
      return;
    }

    final move = BoardMove(
      cellIndex: index,
      previousValue: current.values[index],
      previousNotes: {...current.notes[index]},
    );

    final newValues = Uint8List.fromList(current.values);
    newValues[index] = value;
    final newNotes = List<Set<int>>.generate(
      current.notes.length,
      (i) => i == index ? <int>{} : current.notes[i],
    );

    final isCorrect = current.solution[index] == value;
    final newMistakes = isCorrect ? current.mistakes : current.mistakes + 1;
    final isComplete = _boardMatchesSolution(newValues, current.solution);

    state = current.copyWith(
      values: newValues,
      notes: newNotes,
      mistakes: newMistakes,
      isComplete: isComplete,
      undoStack: [...current.undoStack, move],
    );

    if (isComplete) _ticker?.cancel();
  }

  void clearSelectedCell() {
    final current = state;
    if (current == null) return;
    final row = current.selectedRow;
    final col = current.selectedCol;
    if (row == null || col == null) return;
    if (current.isGiven(row, col)) return;

    final index = current.cellIndex(row, col);
    if (current.values[index] == 0 && current.notes[index].isEmpty) return;

    final move = BoardMove(
      cellIndex: index,
      previousValue: current.values[index],
      previousNotes: {...current.notes[index]},
    );

    final newValues = Uint8List.fromList(current.values);
    newValues[index] = 0;
    final newNotes = List<Set<int>>.generate(
      current.notes.length,
      (i) => i == index ? <int>{} : current.notes[i],
    );

    state = current.copyWith(
      values: newValues,
      notes: newNotes,
      undoStack: [...current.undoStack, move],
    );
  }

  void undo() {
    final current = state;
    if (current == null || !current.canUndo) return;

    final move = current.undoStack.last;
    final newValues = Uint8List.fromList(current.values);
    newValues[move.cellIndex] = move.previousValue;
    final newNotes = List<Set<int>>.generate(
      current.notes.length,
      (i) => i == move.cellIndex ? {...move.previousNotes} : current.notes[i],
    );

    state = current.copyWith(
      values: newValues,
      notes: newNotes,
      undoStack: current.undoStack.sublist(0, current.undoStack.length - 1),
      isComplete: false,
    );
  }

  void useHint() {
    final current = state;
    if (current == null) return;
    final row = current.selectedRow;
    final col = current.selectedCol;
    if (row == null || col == null) return;
    if (current.isGiven(row, col)) return;

    final index = current.cellIndex(row, col);
    final correctValue = current.solution[index];

    final newValues = Uint8List.fromList(current.values);
    newValues[index] = correctValue;
    final newNotes = List<Set<int>>.generate(
      current.notes.length,
      (i) => i == index ? <int>{} : current.notes[i],
    );

    final isComplete = _boardMatchesSolution(newValues, current.solution);

    state = current.copyWith(
      values: newValues,
      notes: newNotes,
      isComplete: isComplete,
    );

    if (isComplete) _ticker?.cancel();
  }

  bool _boardMatchesSolution(Uint8List values, Uint8List solution) {
    for (var i = 0; i < values.length; i++) {
      if (values[i] != solution[i]) return false;
    }
    return true;
  }
}

final gameControllerProvider =
    NotifierProvider<GameController, GameBoardState?>(GameController.new);
