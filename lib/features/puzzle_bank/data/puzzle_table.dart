import 'package:drift/drift.dart';

/// A puzzle bank row. [puzzle] and [solution] are stored as comma-separated
/// row-major cell values (0 = blank) rather than fixed-width digit strings,
/// since values can go up to 16 for the largest grid size.
class Puzzles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gridSize => integer()();
  TextColumn get difficulty => text()();
  IntColumn get clueCount => integer()();
  TextColumn get puzzle => text()();
  TextColumn get solution => text()();
  TextColumn get source => text()();
  BoolColumn get used => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
