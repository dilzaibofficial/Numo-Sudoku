// Offline dev tool — NOT shipped in the app.
// Reads the ETL output CSV (tools/kaggle_pipeline/output/puzzle_bank_9x9.csv)
// and writes a pre-populated SQLite file that gets bundled as a Flutter
// asset and copied into the app's documents directory on first launch.
//
// Usage:
//   dart run tools/generate_bank/seed_from_csv.dart [csvPath] [outputPath]
//
// Defaults:
//   csvPath    = tools/kaggle_pipeline/output/puzzle_bank_9x9.csv
//   outputPath = assets/puzzles/numo_sudoku_seed.sqlite

import 'dart:io';

import 'package:drift/native.dart';
import 'package:numo_sudoku/features/puzzle_bank/data/app_database.dart';

Future<void> main(List<String> args) async {
  final csvPath =
      args.isNotEmpty ? args[0] : 'tools/kaggle_pipeline/output/puzzle_bank_9x9.csv';
  final outputPath = args.length > 1 ? args[1] : 'assets/puzzles/numo_sudoku_seed.sqlite';

  final csvFile = File(csvPath);
  if (!csvFile.existsSync()) {
    stderr.writeln('CSV not found: $csvPath (run the Python ETL script first)');
    exit(1);
  }

  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  if (outputFile.existsSync()) outputFile.deleteSync();

  final db = AppDatabase.withExecutor(NativeDatabase(outputFile));

  final lines = csvFile.readAsLinesSync();
  final entries = <PuzzlesCompanion>[];
  for (final line in lines.skip(1)) {
    if (line.trim().isEmpty) continue;
    final parts = line.split(',');
    entries.add(PuzzlesCompanion.insert(
      gridSize: int.parse(parts[0]),
      difficulty: parts[1],
      clueCount: int.parse(parts[2]),
      puzzle: parts[3].replaceAll('|', ','),
      solution: parts[4].replaceAll('|', ','),
      source: parts[5],
    ));
  }

  const batchSize = 500;
  for (var i = 0; i < entries.length; i += batchSize) {
    final end = (i + batchSize < entries.length) ? i + batchSize : entries.length;
    await db.insertPuzzles(entries.sublist(i, end));
    stdout.writeln('Inserted $end/${entries.length}');
  }

  await db.close();
  stdout.writeln('Done. Wrote ${entries.length} puzzles to $outputPath');
}
