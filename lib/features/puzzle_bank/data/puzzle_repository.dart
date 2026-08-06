import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
  final db = AppDatabase.withExecutor(_openConnection());
  ref.onDispose(db.close);
  return db;
});

final puzzleRepositoryProvider = Provider<PuzzleRepository>((ref) {
  return PuzzleRepository(ref.watch(appDatabaseProvider));
});

/// On first launch, seeds the real on-device database from the bundled
/// Kaggle-derived puzzle bank (built offline by tools/generate_bank) so the
/// app has puzzles to serve without any network call. If that asset hasn't
/// been built yet (early development), falls back to an empty database —
/// the on-device generator covers the gap (see GameController).
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'numo_sudoku.sqlite'));
    if (!file.existsSync()) {
      try {
        final seedBytes = await rootBundle.load('assets/puzzles/numo_sudoku_seed.sqlite');
        await file.writeAsBytes(seedBytes.buffer.asUint8List(
          seedBytes.offsetInBytes,
          seedBytes.lengthInBytes,
        ));
      } catch (_) {
        // No bundled seed asset yet.
      }
    }
    return NativeDatabase.createInBackground(file);
  });
}
