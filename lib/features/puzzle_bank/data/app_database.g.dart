// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PuzzlesTable extends Puzzles with TableInfo<$PuzzlesTable, Puzzle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PuzzlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gridSizeMeta = const VerificationMeta(
    'gridSize',
  );
  @override
  late final GeneratedColumn<int> gridSize = GeneratedColumn<int>(
    'grid_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clueCountMeta = const VerificationMeta(
    'clueCount',
  );
  @override
  late final GeneratedColumn<int> clueCount = GeneratedColumn<int>(
    'clue_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _puzzleMeta = const VerificationMeta('puzzle');
  @override
  late final GeneratedColumn<String> puzzle = GeneratedColumn<String>(
    'puzzle',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _solutionMeta = const VerificationMeta(
    'solution',
  );
  @override
  late final GeneratedColumn<String> solution = GeneratedColumn<String>(
    'solution',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedMeta = const VerificationMeta('used');
  @override
  late final GeneratedColumn<bool> used = GeneratedColumn<bool>(
    'used',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("used" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gridSize,
    difficulty,
    clueCount,
    puzzle,
    solution,
    source,
    used,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'puzzles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Puzzle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('grid_size')) {
      context.handle(
        _gridSizeMeta,
        gridSize.isAcceptableOrUnknown(data['grid_size']!, _gridSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_gridSizeMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('clue_count')) {
      context.handle(
        _clueCountMeta,
        clueCount.isAcceptableOrUnknown(data['clue_count']!, _clueCountMeta),
      );
    } else if (isInserting) {
      context.missing(_clueCountMeta);
    }
    if (data.containsKey('puzzle')) {
      context.handle(
        _puzzleMeta,
        puzzle.isAcceptableOrUnknown(data['puzzle']!, _puzzleMeta),
      );
    } else if (isInserting) {
      context.missing(_puzzleMeta);
    }
    if (data.containsKey('solution')) {
      context.handle(
        _solutionMeta,
        solution.isAcceptableOrUnknown(data['solution']!, _solutionMeta),
      );
    } else if (isInserting) {
      context.missing(_solutionMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('used')) {
      context.handle(
        _usedMeta,
        used.isAcceptableOrUnknown(data['used']!, _usedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Puzzle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Puzzle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      gridSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grid_size'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      clueCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clue_count'],
      )!,
      puzzle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}puzzle'],
      )!,
      solution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}solution'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      used: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PuzzlesTable createAlias(String alias) {
    return $PuzzlesTable(attachedDatabase, alias);
  }
}

class Puzzle extends DataClass implements Insertable<Puzzle> {
  final int id;
  final int gridSize;
  final String difficulty;
  final int clueCount;
  final String puzzle;
  final String solution;
  final String source;
  final bool used;
  final DateTime createdAt;
  const Puzzle({
    required this.id,
    required this.gridSize,
    required this.difficulty,
    required this.clueCount,
    required this.puzzle,
    required this.solution,
    required this.source,
    required this.used,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['grid_size'] = Variable<int>(gridSize);
    map['difficulty'] = Variable<String>(difficulty);
    map['clue_count'] = Variable<int>(clueCount);
    map['puzzle'] = Variable<String>(puzzle);
    map['solution'] = Variable<String>(solution);
    map['source'] = Variable<String>(source);
    map['used'] = Variable<bool>(used);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PuzzlesCompanion toCompanion(bool nullToAbsent) {
    return PuzzlesCompanion(
      id: Value(id),
      gridSize: Value(gridSize),
      difficulty: Value(difficulty),
      clueCount: Value(clueCount),
      puzzle: Value(puzzle),
      solution: Value(solution),
      source: Value(source),
      used: Value(used),
      createdAt: Value(createdAt),
    );
  }

  factory Puzzle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Puzzle(
      id: serializer.fromJson<int>(json['id']),
      gridSize: serializer.fromJson<int>(json['gridSize']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      clueCount: serializer.fromJson<int>(json['clueCount']),
      puzzle: serializer.fromJson<String>(json['puzzle']),
      solution: serializer.fromJson<String>(json['solution']),
      source: serializer.fromJson<String>(json['source']),
      used: serializer.fromJson<bool>(json['used']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gridSize': serializer.toJson<int>(gridSize),
      'difficulty': serializer.toJson<String>(difficulty),
      'clueCount': serializer.toJson<int>(clueCount),
      'puzzle': serializer.toJson<String>(puzzle),
      'solution': serializer.toJson<String>(solution),
      'source': serializer.toJson<String>(source),
      'used': serializer.toJson<bool>(used),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Puzzle copyWith({
    int? id,
    int? gridSize,
    String? difficulty,
    int? clueCount,
    String? puzzle,
    String? solution,
    String? source,
    bool? used,
    DateTime? createdAt,
  }) => Puzzle(
    id: id ?? this.id,
    gridSize: gridSize ?? this.gridSize,
    difficulty: difficulty ?? this.difficulty,
    clueCount: clueCount ?? this.clueCount,
    puzzle: puzzle ?? this.puzzle,
    solution: solution ?? this.solution,
    source: source ?? this.source,
    used: used ?? this.used,
    createdAt: createdAt ?? this.createdAt,
  );
  Puzzle copyWithCompanion(PuzzlesCompanion data) {
    return Puzzle(
      id: data.id.present ? data.id.value : this.id,
      gridSize: data.gridSize.present ? data.gridSize.value : this.gridSize,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      clueCount: data.clueCount.present ? data.clueCount.value : this.clueCount,
      puzzle: data.puzzle.present ? data.puzzle.value : this.puzzle,
      solution: data.solution.present ? data.solution.value : this.solution,
      source: data.source.present ? data.source.value : this.source,
      used: data.used.present ? data.used.value : this.used,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Puzzle(')
          ..write('id: $id, ')
          ..write('gridSize: $gridSize, ')
          ..write('difficulty: $difficulty, ')
          ..write('clueCount: $clueCount, ')
          ..write('puzzle: $puzzle, ')
          ..write('solution: $solution, ')
          ..write('source: $source, ')
          ..write('used: $used, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gridSize,
    difficulty,
    clueCount,
    puzzle,
    solution,
    source,
    used,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Puzzle &&
          other.id == this.id &&
          other.gridSize == this.gridSize &&
          other.difficulty == this.difficulty &&
          other.clueCount == this.clueCount &&
          other.puzzle == this.puzzle &&
          other.solution == this.solution &&
          other.source == this.source &&
          other.used == this.used &&
          other.createdAt == this.createdAt);
}

class PuzzlesCompanion extends UpdateCompanion<Puzzle> {
  final Value<int> id;
  final Value<int> gridSize;
  final Value<String> difficulty;
  final Value<int> clueCount;
  final Value<String> puzzle;
  final Value<String> solution;
  final Value<String> source;
  final Value<bool> used;
  final Value<DateTime> createdAt;
  const PuzzlesCompanion({
    this.id = const Value.absent(),
    this.gridSize = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.clueCount = const Value.absent(),
    this.puzzle = const Value.absent(),
    this.solution = const Value.absent(),
    this.source = const Value.absent(),
    this.used = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PuzzlesCompanion.insert({
    this.id = const Value.absent(),
    required int gridSize,
    required String difficulty,
    required int clueCount,
    required String puzzle,
    required String solution,
    required String source,
    this.used = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : gridSize = Value(gridSize),
       difficulty = Value(difficulty),
       clueCount = Value(clueCount),
       puzzle = Value(puzzle),
       solution = Value(solution),
       source = Value(source);
  static Insertable<Puzzle> custom({
    Expression<int>? id,
    Expression<int>? gridSize,
    Expression<String>? difficulty,
    Expression<int>? clueCount,
    Expression<String>? puzzle,
    Expression<String>? solution,
    Expression<String>? source,
    Expression<bool>? used,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gridSize != null) 'grid_size': gridSize,
      if (difficulty != null) 'difficulty': difficulty,
      if (clueCount != null) 'clue_count': clueCount,
      if (puzzle != null) 'puzzle': puzzle,
      if (solution != null) 'solution': solution,
      if (source != null) 'source': source,
      if (used != null) 'used': used,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PuzzlesCompanion copyWith({
    Value<int>? id,
    Value<int>? gridSize,
    Value<String>? difficulty,
    Value<int>? clueCount,
    Value<String>? puzzle,
    Value<String>? solution,
    Value<String>? source,
    Value<bool>? used,
    Value<DateTime>? createdAt,
  }) {
    return PuzzlesCompanion(
      id: id ?? this.id,
      gridSize: gridSize ?? this.gridSize,
      difficulty: difficulty ?? this.difficulty,
      clueCount: clueCount ?? this.clueCount,
      puzzle: puzzle ?? this.puzzle,
      solution: solution ?? this.solution,
      source: source ?? this.source,
      used: used ?? this.used,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (gridSize.present) {
      map['grid_size'] = Variable<int>(gridSize.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (clueCount.present) {
      map['clue_count'] = Variable<int>(clueCount.value);
    }
    if (puzzle.present) {
      map['puzzle'] = Variable<String>(puzzle.value);
    }
    if (solution.present) {
      map['solution'] = Variable<String>(solution.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (used.present) {
      map['used'] = Variable<bool>(used.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PuzzlesCompanion(')
          ..write('id: $id, ')
          ..write('gridSize: $gridSize, ')
          ..write('difficulty: $difficulty, ')
          ..write('clueCount: $clueCount, ')
          ..write('puzzle: $puzzle, ')
          ..write('solution: $solution, ')
          ..write('source: $source, ')
          ..write('used: $used, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PuzzlesTable puzzles = $PuzzlesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [puzzles];
}

typedef $$PuzzlesTableCreateCompanionBuilder =
    PuzzlesCompanion Function({
      Value<int> id,
      required int gridSize,
      required String difficulty,
      required int clueCount,
      required String puzzle,
      required String solution,
      required String source,
      Value<bool> used,
      Value<DateTime> createdAt,
    });
typedef $$PuzzlesTableUpdateCompanionBuilder =
    PuzzlesCompanion Function({
      Value<int> id,
      Value<int> gridSize,
      Value<String> difficulty,
      Value<int> clueCount,
      Value<String> puzzle,
      Value<String> solution,
      Value<String> source,
      Value<bool> used,
      Value<DateTime> createdAt,
    });

class $$PuzzlesTableFilterComposer
    extends Composer<_$AppDatabase, $PuzzlesTable> {
  $$PuzzlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clueCount => $composableBuilder(
    column: $table.clueCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get puzzle => $composableBuilder(
    column: $table.puzzle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get solution => $composableBuilder(
    column: $table.solution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PuzzlesTableOrderingComposer
    extends Composer<_$AppDatabase, $PuzzlesTable> {
  $$PuzzlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gridSize => $composableBuilder(
    column: $table.gridSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clueCount => $composableBuilder(
    column: $table.clueCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get puzzle => $composableBuilder(
    column: $table.puzzle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get solution => $composableBuilder(
    column: $table.solution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get used => $composableBuilder(
    column: $table.used,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PuzzlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PuzzlesTable> {
  $$PuzzlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get gridSize =>
      $composableBuilder(column: $table.gridSize, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clueCount =>
      $composableBuilder(column: $table.clueCount, builder: (column) => column);

  GeneratedColumn<String> get puzzle =>
      $composableBuilder(column: $table.puzzle, builder: (column) => column);

  GeneratedColumn<String> get solution =>
      $composableBuilder(column: $table.solution, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get used =>
      $composableBuilder(column: $table.used, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PuzzlesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PuzzlesTable,
          Puzzle,
          $$PuzzlesTableFilterComposer,
          $$PuzzlesTableOrderingComposer,
          $$PuzzlesTableAnnotationComposer,
          $$PuzzlesTableCreateCompanionBuilder,
          $$PuzzlesTableUpdateCompanionBuilder,
          (Puzzle, BaseReferences<_$AppDatabase, $PuzzlesTable, Puzzle>),
          Puzzle,
          PrefetchHooks Function()
        > {
  $$PuzzlesTableTableManager(_$AppDatabase db, $PuzzlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PuzzlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PuzzlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PuzzlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gridSize = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<int> clueCount = const Value.absent(),
                Value<String> puzzle = const Value.absent(),
                Value<String> solution = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> used = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PuzzlesCompanion(
                id: id,
                gridSize: gridSize,
                difficulty: difficulty,
                clueCount: clueCount,
                puzzle: puzzle,
                solution: solution,
                source: source,
                used: used,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gridSize,
                required String difficulty,
                required int clueCount,
                required String puzzle,
                required String solution,
                required String source,
                Value<bool> used = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PuzzlesCompanion.insert(
                id: id,
                gridSize: gridSize,
                difficulty: difficulty,
                clueCount: clueCount,
                puzzle: puzzle,
                solution: solution,
                source: source,
                used: used,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PuzzlesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PuzzlesTable,
      Puzzle,
      $$PuzzlesTableFilterComposer,
      $$PuzzlesTableOrderingComposer,
      $$PuzzlesTableAnnotationComposer,
      $$PuzzlesTableCreateCompanionBuilder,
      $$PuzzlesTableUpdateCompanionBuilder,
      (Puzzle, BaseReferences<_$AppDatabase, $PuzzlesTable, Puzzle>),
      Puzzle,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PuzzlesTableTableManager get puzzles =>
      $$PuzzlesTableTableManager(_db, _db.puzzles);
}
