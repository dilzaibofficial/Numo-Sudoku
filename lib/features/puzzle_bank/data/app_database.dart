import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'puzzle_table.dart';

part 'app_database.g.dart';

String encodeBoard(Uint8List board) => board.join(',');

Uint8List decodeBoard(String encoded) =>
    Uint8List.fromList(encoded.split(',').map(int.parse).toList());

@DriftDatabase(tables: [Puzzles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;

  Future<Puzzle?> takeUnusedPuzzle({
    required int gridSize,
    required String difficulty,
  }) async {
    final row = await (select(puzzles)
          ..where((p) =>
              p.gridSize.equals(gridSize) &
              p.difficulty.equals(difficulty) &
              p.used.equals(false))
          ..limit(1))
        .getSingleOrNull();
    if (row != null) {
      await (update(puzzles)..where((p) => p.id.equals(row.id)))
          .write(const PuzzlesCompanion(used: Value(true)));
    }
    return row;
  }

  Future<int> countUnused({required int gridSize, required String difficulty}) async {
    final countExp = puzzles.id.count();
    final query = selectOnly(puzzles)
      ..addColumns([countExp])
      ..where(puzzles.gridSize.equals(gridSize) &
          puzzles.difficulty.equals(difficulty) &
          puzzles.used.equals(false));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<void> insertPuzzles(List<PuzzlesCompanion> entries) async {
    await batch((batch) => batch.insertAll(puzzles, entries));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'numo_sudoku.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
