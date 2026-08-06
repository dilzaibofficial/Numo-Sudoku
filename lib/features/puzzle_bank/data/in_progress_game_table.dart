import 'package:drift/drift.dart';

/// A single-row table (id is always 1) holding the one active in-progress
/// game, so it survives an app restart. The undo stack is intentionally not
/// persisted — resuming with a clean undo history is an acceptable trade-off.
class InProgressGames extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get gridSize => integer()();
  TextColumn get givens => text()();
  TextColumn get values => text()();
  TextColumn get solution => text()();
  TextColumn get notes => text()();
  IntColumn get selectedRow => integer().nullable()();
  IntColumn get selectedCol => integer().nullable()();
  BoolColumn get notesMode => boolean().withDefault(const Constant(false))();
  IntColumn get mistakes => integer().withDefault(const Constant(0))();
  IntColumn get elapsedSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
