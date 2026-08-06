import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sudoku_engine/domain/difficulty.dart';
import '../../sudoku_engine/domain/grid_spec.dart';
import '../../sudoku_engine/generator/sudoku_generator.dart';
import 'app_database.dart';

String difficultyKey(PuzzleDifficulty difficulty) => difficulty.name;

class PuzzleBankEntry {
  const PuzzleBankEntry({
    required this.puzzle,
    required this.solution,
    required this.clueCount,
  });

  final Uint8List puzzle;
  final Uint8List solution;
  final int clueCount;
}

class PuzzleRepository {
  PuzzleRepository(this._db);

  final AppDatabase _db;

  Future<PuzzleBankEntry?> takePuzzle({
    required GridSpec spec,
    required PuzzleDifficulty difficulty,
  }) async {
    final row = await _db.takeUnusedPuzzle(
      gridSize: spec.size,
      difficulty: difficultyKey(difficulty),
    );
    if (row == null) return null;
    return PuzzleBankEntry(
      puzzle: decodeBoard(row.puzzle),
      solution: decodeBoard(row.solution),
      clueCount: row.clueCount,
    );
  }

  Future<void> addGeneratedPuzzle(
    GeneratedPuzzle generated, {
    String source = 'generated',
  }) {
    final difficulty =
        DifficultyTable.classify(generated.spec.cellCount, generated.clueCount) ??
            PuzzleDifficulty.normal;
    return _db.insertPuzzles([
      PuzzlesCompanion.insert(
        gridSize: generated.spec.size,
        difficulty: difficultyKey(difficulty),
        clueCount: generated.clueCount,
        puzzle: encodeBoard(generated.puzzle),
        solution: encodeBoard(generated.solution),
        source: source,
      ),
    ]);
  }

  Future<int> availableCount({
    required GridSpec spec,
    required PuzzleDifficulty difficulty,
  }) {
    return _db.countUnused(gridSize: spec.size, difficulty: difficultyKey(difficulty));
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final puzzleRepositoryProvider = Provider<PuzzleRepository>((ref) {
  return PuzzleRepository(ref.watch(appDatabaseProvider));
});
