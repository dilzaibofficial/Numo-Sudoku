// Offline dev tool — NOT shipped in the app.
// Generates puzzle banks for the 4 grid sizes that have no Kaggle source
// (4x4, 6x6, 12x12, 16x16) using the app's own sudoku_engine, and appends
// them to the same bundled seed database the Kaggle pipeline writes to.
//
// Usage: dart run tools/generate_bank/generate_sizes.dart

import 'dart:io';
import 'dart:math';

import 'package:drift/native.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/app_database.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/difficulty.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';
import 'package:numo_sudoku/features/sudoku_engine/generator/sudoku_generator.dart';

const _countPerBand = {
  16: 300, // 4x4
  36: 300, // 6x6
  144: 150, // 12x12
  256: 80, // 16x16
};

Future<void> main() async {
  const outputPath = 'assets/puzzles/numo_sudoku_seed.sqlite';
  final outputFile = File(outputPath);
  if (!outputFile.existsSync()) {
    stderr.writeln('Seed DB not found at $outputPath — run the Kaggle seed script first.');
    exit(1);
  }

  final db = AppDatabase.withExecutor(NativeDatabase(outputFile));
  final random = Random(2026);
  final specs = [GridSpec.size4, GridSpec.size6, GridSpec.size12, GridSpec.size16];

  for (final spec in specs) {
    final countPerBand = _countPerBand[spec.cellCount]!;
    final generator = SudokuGenerator(spec);

    for (final difficulty in PuzzleDifficulty.values) {
      final range = DifficultyTable.rangeFor(spec.cellCount, difficulty)!;
      final entries = <PuzzlesCompanion>[];

      for (var i = 0; i < countPerBand; i++) {
        final target = range.min + random.nextInt(range.max - range.min + 1);
        final generated = generator.generate(
          random: random,
          targetClueCount: target,
          timeBudget: const Duration(seconds: 3),
        );
        entries.add(PuzzlesCompanion.insert(
          gridSize: spec.size,
          difficulty: difficulty.name,
          clueCount: generated.clueCount,
          puzzle: encodeBoard(generated.puzzle),
          solution: encodeBoard(generated.solution),
          source: 'generated',
        ));
      }

      await db.insertPuzzles(entries);
      stdout.writeln('${spec.size}x${spec.size} ${difficulty.name}: $countPerBand puzzles');
    }
  }

  await db.close();
  stdout.writeln('Done.');
}
