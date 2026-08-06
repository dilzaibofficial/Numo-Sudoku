import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../puzzle_bank/data/app_database.dart';
import '../../puzzle_bank/data/puzzle_repository.dart';
import '../../sudoku_engine/domain/grid_spec.dart';
import '../domain/game_board_state.dart';

/// Persists and restores the single active in-progress game so it survives
/// an app restart. The undo stack is not persisted (see InProgressGames).
class GameSessionRepository {
  GameSessionRepository(this._db);

  final AppDatabase _db;

  Future<void> save(GameBoardState state) {
    return _db.saveInProgressGame(
      InProgressGamesCompanion.insert(
        id: const Value(1),
        gridSize: state.spec.size,
        givens: encodeBoard(state.givens),
        values: encodeBoard(state.values),
        solution: encodeBoard(state.solution),
        notes: encodeNotes(state.notes),
        selectedRow: Value(state.selectedRow),
        selectedCol: Value(state.selectedCol),
        notesMode: Value(state.notesMode),
        mistakes: Value(state.mistakes),
        elapsedSeconds: Value(state.elapsed.inSeconds),
        isComplete: Value(state.isComplete),
      ),
    );
  }

  Future<GameBoardState?> load() async {
    final row = await _db.loadInProgressGame();
    if (row == null) return null;

    final spec = GridSpec.all.firstWhere((s) => s.size == row.gridSize);
    return GameBoardState(
      spec: spec,
      givens: decodeBoard(row.givens),
      values: decodeBoard(row.values),
      solution: decodeBoard(row.solution),
      notes: decodeNotes(row.notes),
      selectedRow: row.selectedRow,
      selectedCol: row.selectedCol,
      notesMode: row.notesMode,
      mistakes: row.mistakes,
      elapsed: Duration(seconds: row.elapsedSeconds),
      isComplete: row.isComplete,
    );
  }

  Future<void> clear() => _db.clearInProgressGame();
}

final gameSessionRepositoryProvider = Provider<GameSessionRepository>((ref) {
  return GameSessionRepository(ref.watch(appDatabaseProvider));
});
