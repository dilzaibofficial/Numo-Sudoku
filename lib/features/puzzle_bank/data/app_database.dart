import 'package:drift/drift.dart';

import 'in_progress_game_table.dart';
import 'puzzle_table.dart';

part 'app_database.g.dart';

String encodeBoard(Uint8List board) => board.join(',');

Uint8List decodeBoard(String encoded) =>
    Uint8List.fromList(encoded.split(',').map(int.parse).toList());

String encodeNotes(List<Set<int>> notes) =>
    notes.map((cellNotes) => cellNotes.join(',')).join(';');

List<Set<int>> decodeNotes(String encoded) {
  if (encoded.isEmpty) return [];
  return encoded.split(';').map((cell) {
    if (cell.isEmpty) return <int>{};
    return cell.split(',').map(int.parse).toSet();
  }).toList();
}

String encodeIndexSet(Set<int> indices) => indices.join(',');

Set<int> decodeIndexSet(String encoded) =>
    encoded.isEmpty ? {} : encoded.split(',').map(int.parse).toSet();

@DriftDatabase(tables: [Puzzles, InProgressGames])
class AppDatabase extends _$AppDatabase {
  /// Deliberately kept free of any Flutter dependency (no path_provider)
  /// so this class — and anything that imports it — stays runnable under
  /// plain `dart run` (used by the offline puzzle-bank seed CLI) as well
  /// as `flutter test`. The real app's app-documents-directory connection
  /// is constructed in puzzle_repository.dart, where Flutter is already a
  /// given.
  AppDatabase.withExecutor(super.connection);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(inProgressGames);
          if (from < 3) {
            await m.addColumn(inProgressGames, inProgressGames.difficulty);
            await m.addColumn(inProgressGames, inProgressGames.hintedCells);
          }
        },
      );

  Future<void> saveInProgressGame(InProgressGamesCompanion entry) async {
    await into(inProgressGames).insertOnConflictUpdate(entry);
  }

  Future<InProgressGame?> loadInProgressGame() {
    return (select(inProgressGames)..where((g) => g.id.equals(1))).getSingleOrNull();
  }

  Future<void> clearInProgressGame() async {
    await (delete(inProgressGames)..where((g) => g.id.equals(1))).go();
  }

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
