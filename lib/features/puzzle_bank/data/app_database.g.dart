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

class $InProgressGamesTable extends InProgressGames
    with TableInfo<$InProgressGamesTable, InProgressGame> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InProgressGamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _givensMeta = const VerificationMeta('givens');
  @override
  late final GeneratedColumn<String> givens = GeneratedColumn<String>(
    'givens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valuesMeta = const VerificationMeta('values');
  @override
  late final GeneratedColumn<String> values = GeneratedColumn<String>(
    'values',
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintedCellsMeta = const VerificationMeta(
    'hintedCells',
  );
  @override
  late final GeneratedColumn<String> hintedCells = GeneratedColumn<String>(
    'hinted_cells',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _selectedRowMeta = const VerificationMeta(
    'selectedRow',
  );
  @override
  late final GeneratedColumn<int> selectedRow = GeneratedColumn<int>(
    'selected_row',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _selectedColMeta = const VerificationMeta(
    'selectedCol',
  );
  @override
  late final GeneratedColumn<int> selectedCol = GeneratedColumn<int>(
    'selected_col',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesModeMeta = const VerificationMeta(
    'notesMode',
  );
  @override
  late final GeneratedColumn<bool> notesMode = GeneratedColumn<bool>(
    'notes_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notes_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _mistakesMeta = const VerificationMeta(
    'mistakes',
  );
  @override
  late final GeneratedColumn<int> mistakes = GeneratedColumn<int>(
    'mistakes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    gridSize,
    difficulty,
    givens,
    values,
    solution,
    notes,
    hintedCells,
    selectedRow,
    selectedCol,
    notesMode,
    mistakes,
    elapsedSeconds,
    isComplete,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'in_progress_games';
  @override
  VerificationContext validateIntegrity(
    Insertable<InProgressGame> instance, {
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
    }
    if (data.containsKey('givens')) {
      context.handle(
        _givensMeta,
        givens.isAcceptableOrUnknown(data['givens']!, _givensMeta),
      );
    } else if (isInserting) {
      context.missing(_givensMeta);
    }
    if (data.containsKey('values')) {
      context.handle(
        _valuesMeta,
        values.isAcceptableOrUnknown(data['values']!, _valuesMeta),
      );
    } else if (isInserting) {
      context.missing(_valuesMeta);
    }
    if (data.containsKey('solution')) {
      context.handle(
        _solutionMeta,
        solution.isAcceptableOrUnknown(data['solution']!, _solutionMeta),
      );
    } else if (isInserting) {
      context.missing(_solutionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('hinted_cells')) {
      context.handle(
        _hintedCellsMeta,
        hintedCells.isAcceptableOrUnknown(
          data['hinted_cells']!,
          _hintedCellsMeta,
        ),
      );
    }
    if (data.containsKey('selected_row')) {
      context.handle(
        _selectedRowMeta,
        selectedRow.isAcceptableOrUnknown(
          data['selected_row']!,
          _selectedRowMeta,
        ),
      );
    }
    if (data.containsKey('selected_col')) {
      context.handle(
        _selectedColMeta,
        selectedCol.isAcceptableOrUnknown(
          data['selected_col']!,
          _selectedColMeta,
        ),
      );
    }
    if (data.containsKey('notes_mode')) {
      context.handle(
        _notesModeMeta,
        notesMode.isAcceptableOrUnknown(data['notes_mode']!, _notesModeMeta),
      );
    }
    if (data.containsKey('mistakes')) {
      context.handle(
        _mistakesMeta,
        mistakes.isAcceptableOrUnknown(data['mistakes']!, _mistakesMeta),
      );
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InProgressGame map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InProgressGame(
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
      givens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}givens'],
      )!,
      values: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}values'],
      )!,
      solution: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}solution'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      hintedCells: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hinted_cells'],
      )!,
      selectedRow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_row'],
      ),
      selectedCol: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_col'],
      ),
      notesMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notes_mode'],
      )!,
      mistakes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mistakes'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
    );
  }

  @override
  $InProgressGamesTable createAlias(String alias) {
    return $InProgressGamesTable(attachedDatabase, alias);
  }
}

class InProgressGame extends DataClass implements Insertable<InProgressGame> {
  final int id;
  final int gridSize;
  final String difficulty;
  final String givens;
  final String values;
  final String solution;
  final String notes;
  final String hintedCells;
  final int? selectedRow;
  final int? selectedCol;
  final bool notesMode;
  final int mistakes;
  final int elapsedSeconds;
  final bool isComplete;
  const InProgressGame({
    required this.id,
    required this.gridSize,
    required this.difficulty,
    required this.givens,
    required this.values,
    required this.solution,
    required this.notes,
    required this.hintedCells,
    this.selectedRow,
    this.selectedCol,
    required this.notesMode,
    required this.mistakes,
    required this.elapsedSeconds,
    required this.isComplete,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['grid_size'] = Variable<int>(gridSize);
    map['difficulty'] = Variable<String>(difficulty);
    map['givens'] = Variable<String>(givens);
    map['values'] = Variable<String>(values);
    map['solution'] = Variable<String>(solution);
    map['notes'] = Variable<String>(notes);
    map['hinted_cells'] = Variable<String>(hintedCells);
    if (!nullToAbsent || selectedRow != null) {
      map['selected_row'] = Variable<int>(selectedRow);
    }
    if (!nullToAbsent || selectedCol != null) {
      map['selected_col'] = Variable<int>(selectedCol);
    }
    map['notes_mode'] = Variable<bool>(notesMode);
    map['mistakes'] = Variable<int>(mistakes);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    map['is_complete'] = Variable<bool>(isComplete);
    return map;
  }

  InProgressGamesCompanion toCompanion(bool nullToAbsent) {
    return InProgressGamesCompanion(
      id: Value(id),
      gridSize: Value(gridSize),
      difficulty: Value(difficulty),
      givens: Value(givens),
      values: Value(values),
      solution: Value(solution),
      notes: Value(notes),
      hintedCells: Value(hintedCells),
      selectedRow: selectedRow == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedRow),
      selectedCol: selectedCol == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedCol),
      notesMode: Value(notesMode),
      mistakes: Value(mistakes),
      elapsedSeconds: Value(elapsedSeconds),
      isComplete: Value(isComplete),
    );
  }

  factory InProgressGame.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InProgressGame(
      id: serializer.fromJson<int>(json['id']),
      gridSize: serializer.fromJson<int>(json['gridSize']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      givens: serializer.fromJson<String>(json['givens']),
      values: serializer.fromJson<String>(json['values']),
      solution: serializer.fromJson<String>(json['solution']),
      notes: serializer.fromJson<String>(json['notes']),
      hintedCells: serializer.fromJson<String>(json['hintedCells']),
      selectedRow: serializer.fromJson<int?>(json['selectedRow']),
      selectedCol: serializer.fromJson<int?>(json['selectedCol']),
      notesMode: serializer.fromJson<bool>(json['notesMode']),
      mistakes: serializer.fromJson<int>(json['mistakes']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'gridSize': serializer.toJson<int>(gridSize),
      'difficulty': serializer.toJson<String>(difficulty),
      'givens': serializer.toJson<String>(givens),
      'values': serializer.toJson<String>(values),
      'solution': serializer.toJson<String>(solution),
      'notes': serializer.toJson<String>(notes),
      'hintedCells': serializer.toJson<String>(hintedCells),
      'selectedRow': serializer.toJson<int?>(selectedRow),
      'selectedCol': serializer.toJson<int?>(selectedCol),
      'notesMode': serializer.toJson<bool>(notesMode),
      'mistakes': serializer.toJson<int>(mistakes),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
      'isComplete': serializer.toJson<bool>(isComplete),
    };
  }

  InProgressGame copyWith({
    int? id,
    int? gridSize,
    String? difficulty,
    String? givens,
    String? values,
    String? solution,
    String? notes,
    String? hintedCells,
    Value<int?> selectedRow = const Value.absent(),
    Value<int?> selectedCol = const Value.absent(),
    bool? notesMode,
    int? mistakes,
    int? elapsedSeconds,
    bool? isComplete,
  }) => InProgressGame(
    id: id ?? this.id,
    gridSize: gridSize ?? this.gridSize,
    difficulty: difficulty ?? this.difficulty,
    givens: givens ?? this.givens,
    values: values ?? this.values,
    solution: solution ?? this.solution,
    notes: notes ?? this.notes,
    hintedCells: hintedCells ?? this.hintedCells,
    selectedRow: selectedRow.present ? selectedRow.value : this.selectedRow,
    selectedCol: selectedCol.present ? selectedCol.value : this.selectedCol,
    notesMode: notesMode ?? this.notesMode,
    mistakes: mistakes ?? this.mistakes,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    isComplete: isComplete ?? this.isComplete,
  );
  InProgressGame copyWithCompanion(InProgressGamesCompanion data) {
    return InProgressGame(
      id: data.id.present ? data.id.value : this.id,
      gridSize: data.gridSize.present ? data.gridSize.value : this.gridSize,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      givens: data.givens.present ? data.givens.value : this.givens,
      values: data.values.present ? data.values.value : this.values,
      solution: data.solution.present ? data.solution.value : this.solution,
      notes: data.notes.present ? data.notes.value : this.notes,
      hintedCells: data.hintedCells.present
          ? data.hintedCells.value
          : this.hintedCells,
      selectedRow: data.selectedRow.present
          ? data.selectedRow.value
          : this.selectedRow,
      selectedCol: data.selectedCol.present
          ? data.selectedCol.value
          : this.selectedCol,
      notesMode: data.notesMode.present ? data.notesMode.value : this.notesMode,
      mistakes: data.mistakes.present ? data.mistakes.value : this.mistakes,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InProgressGame(')
          ..write('id: $id, ')
          ..write('gridSize: $gridSize, ')
          ..write('difficulty: $difficulty, ')
          ..write('givens: $givens, ')
          ..write('values: $values, ')
          ..write('solution: $solution, ')
          ..write('notes: $notes, ')
          ..write('hintedCells: $hintedCells, ')
          ..write('selectedRow: $selectedRow, ')
          ..write('selectedCol: $selectedCol, ')
          ..write('notesMode: $notesMode, ')
          ..write('mistakes: $mistakes, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    gridSize,
    difficulty,
    givens,
    values,
    solution,
    notes,
    hintedCells,
    selectedRow,
    selectedCol,
    notesMode,
    mistakes,
    elapsedSeconds,
    isComplete,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InProgressGame &&
          other.id == this.id &&
          other.gridSize == this.gridSize &&
          other.difficulty == this.difficulty &&
          other.givens == this.givens &&
          other.values == this.values &&
          other.solution == this.solution &&
          other.notes == this.notes &&
          other.hintedCells == this.hintedCells &&
          other.selectedRow == this.selectedRow &&
          other.selectedCol == this.selectedCol &&
          other.notesMode == this.notesMode &&
          other.mistakes == this.mistakes &&
          other.elapsedSeconds == this.elapsedSeconds &&
          other.isComplete == this.isComplete);
}

class InProgressGamesCompanion extends UpdateCompanion<InProgressGame> {
  final Value<int> id;
  final Value<int> gridSize;
  final Value<String> difficulty;
  final Value<String> givens;
  final Value<String> values;
  final Value<String> solution;
  final Value<String> notes;
  final Value<String> hintedCells;
  final Value<int?> selectedRow;
  final Value<int?> selectedCol;
  final Value<bool> notesMode;
  final Value<int> mistakes;
  final Value<int> elapsedSeconds;
  final Value<bool> isComplete;
  const InProgressGamesCompanion({
    this.id = const Value.absent(),
    this.gridSize = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.givens = const Value.absent(),
    this.values = const Value.absent(),
    this.solution = const Value.absent(),
    this.notes = const Value.absent(),
    this.hintedCells = const Value.absent(),
    this.selectedRow = const Value.absent(),
    this.selectedCol = const Value.absent(),
    this.notesMode = const Value.absent(),
    this.mistakes = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.isComplete = const Value.absent(),
  });
  InProgressGamesCompanion.insert({
    this.id = const Value.absent(),
    required int gridSize,
    this.difficulty = const Value.absent(),
    required String givens,
    required String values,
    required String solution,
    required String notes,
    this.hintedCells = const Value.absent(),
    this.selectedRow = const Value.absent(),
    this.selectedCol = const Value.absent(),
    this.notesMode = const Value.absent(),
    this.mistakes = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.isComplete = const Value.absent(),
  }) : gridSize = Value(gridSize),
       givens = Value(givens),
       values = Value(values),
       solution = Value(solution),
       notes = Value(notes);
  static Insertable<InProgressGame> custom({
    Expression<int>? id,
    Expression<int>? gridSize,
    Expression<String>? difficulty,
    Expression<String>? givens,
    Expression<String>? values,
    Expression<String>? solution,
    Expression<String>? notes,
    Expression<String>? hintedCells,
    Expression<int>? selectedRow,
    Expression<int>? selectedCol,
    Expression<bool>? notesMode,
    Expression<int>? mistakes,
    Expression<int>? elapsedSeconds,
    Expression<bool>? isComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (gridSize != null) 'grid_size': gridSize,
      if (difficulty != null) 'difficulty': difficulty,
      if (givens != null) 'givens': givens,
      if (values != null) 'values': values,
      if (solution != null) 'solution': solution,
      if (notes != null) 'notes': notes,
      if (hintedCells != null) 'hinted_cells': hintedCells,
      if (selectedRow != null) 'selected_row': selectedRow,
      if (selectedCol != null) 'selected_col': selectedCol,
      if (notesMode != null) 'notes_mode': notesMode,
      if (mistakes != null) 'mistakes': mistakes,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (isComplete != null) 'is_complete': isComplete,
    });
  }

  InProgressGamesCompanion copyWith({
    Value<int>? id,
    Value<int>? gridSize,
    Value<String>? difficulty,
    Value<String>? givens,
    Value<String>? values,
    Value<String>? solution,
    Value<String>? notes,
    Value<String>? hintedCells,
    Value<int?>? selectedRow,
    Value<int?>? selectedCol,
    Value<bool>? notesMode,
    Value<int>? mistakes,
    Value<int>? elapsedSeconds,
    Value<bool>? isComplete,
  }) {
    return InProgressGamesCompanion(
      id: id ?? this.id,
      gridSize: gridSize ?? this.gridSize,
      difficulty: difficulty ?? this.difficulty,
      givens: givens ?? this.givens,
      values: values ?? this.values,
      solution: solution ?? this.solution,
      notes: notes ?? this.notes,
      hintedCells: hintedCells ?? this.hintedCells,
      selectedRow: selectedRow ?? this.selectedRow,
      selectedCol: selectedCol ?? this.selectedCol,
      notesMode: notesMode ?? this.notesMode,
      mistakes: mistakes ?? this.mistakes,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isComplete: isComplete ?? this.isComplete,
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
    if (givens.present) {
      map['givens'] = Variable<String>(givens.value);
    }
    if (values.present) {
      map['values'] = Variable<String>(values.value);
    }
    if (solution.present) {
      map['solution'] = Variable<String>(solution.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (hintedCells.present) {
      map['hinted_cells'] = Variable<String>(hintedCells.value);
    }
    if (selectedRow.present) {
      map['selected_row'] = Variable<int>(selectedRow.value);
    }
    if (selectedCol.present) {
      map['selected_col'] = Variable<int>(selectedCol.value);
    }
    if (notesMode.present) {
      map['notes_mode'] = Variable<bool>(notesMode.value);
    }
    if (mistakes.present) {
      map['mistakes'] = Variable<int>(mistakes.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InProgressGamesCompanion(')
          ..write('id: $id, ')
          ..write('gridSize: $gridSize, ')
          ..write('difficulty: $difficulty, ')
          ..write('givens: $givens, ')
          ..write('values: $values, ')
          ..write('solution: $solution, ')
          ..write('notes: $notes, ')
          ..write('hintedCells: $hintedCells, ')
          ..write('selectedRow: $selectedRow, ')
          ..write('selectedCol: $selectedCol, ')
          ..write('notesMode: $notesMode, ')
          ..write('mistakes: $mistakes, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('isComplete: $isComplete')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PuzzlesTable puzzles = $PuzzlesTable(this);
  late final $InProgressGamesTable inProgressGames = $InProgressGamesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    puzzles,
    inProgressGames,
  ];
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
typedef $$InProgressGamesTableCreateCompanionBuilder =
    InProgressGamesCompanion Function({
      Value<int> id,
      required int gridSize,
      Value<String> difficulty,
      required String givens,
      required String values,
      required String solution,
      required String notes,
      Value<String> hintedCells,
      Value<int?> selectedRow,
      Value<int?> selectedCol,
      Value<bool> notesMode,
      Value<int> mistakes,
      Value<int> elapsedSeconds,
      Value<bool> isComplete,
    });
typedef $$InProgressGamesTableUpdateCompanionBuilder =
    InProgressGamesCompanion Function({
      Value<int> id,
      Value<int> gridSize,
      Value<String> difficulty,
      Value<String> givens,
      Value<String> values,
      Value<String> solution,
      Value<String> notes,
      Value<String> hintedCells,
      Value<int?> selectedRow,
      Value<int?> selectedCol,
      Value<bool> notesMode,
      Value<int> mistakes,
      Value<int> elapsedSeconds,
      Value<bool> isComplete,
    });

class $$InProgressGamesTableFilterComposer
    extends Composer<_$AppDatabase, $InProgressGamesTable> {
  $$InProgressGamesTableFilterComposer({
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

  ColumnFilters<String> get givens => $composableBuilder(
    column: $table.givens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get values => $composableBuilder(
    column: $table.values,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get solution => $composableBuilder(
    column: $table.solution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hintedCells => $composableBuilder(
    column: $table.hintedCells,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedRow => $composableBuilder(
    column: $table.selectedRow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedCol => $composableBuilder(
    column: $table.selectedCol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notesMode => $composableBuilder(
    column: $table.notesMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mistakes => $composableBuilder(
    column: $table.mistakes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InProgressGamesTableOrderingComposer
    extends Composer<_$AppDatabase, $InProgressGamesTable> {
  $$InProgressGamesTableOrderingComposer({
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

  ColumnOrderings<String> get givens => $composableBuilder(
    column: $table.givens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get values => $composableBuilder(
    column: $table.values,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get solution => $composableBuilder(
    column: $table.solution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hintedCells => $composableBuilder(
    column: $table.hintedCells,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedRow => $composableBuilder(
    column: $table.selectedRow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedCol => $composableBuilder(
    column: $table.selectedCol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notesMode => $composableBuilder(
    column: $table.notesMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mistakes => $composableBuilder(
    column: $table.mistakes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InProgressGamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InProgressGamesTable> {
  $$InProgressGamesTableAnnotationComposer({
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

  GeneratedColumn<String> get givens =>
      $composableBuilder(column: $table.givens, builder: (column) => column);

  GeneratedColumn<String> get values =>
      $composableBuilder(column: $table.values, builder: (column) => column);

  GeneratedColumn<String> get solution =>
      $composableBuilder(column: $table.solution, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get hintedCells => $composableBuilder(
    column: $table.hintedCells,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedRow => $composableBuilder(
    column: $table.selectedRow,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedCol => $composableBuilder(
    column: $table.selectedCol,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notesMode =>
      $composableBuilder(column: $table.notesMode, builder: (column) => column);

  GeneratedColumn<int> get mistakes =>
      $composableBuilder(column: $table.mistakes, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );
}

class $$InProgressGamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InProgressGamesTable,
          InProgressGame,
          $$InProgressGamesTableFilterComposer,
          $$InProgressGamesTableOrderingComposer,
          $$InProgressGamesTableAnnotationComposer,
          $$InProgressGamesTableCreateCompanionBuilder,
          $$InProgressGamesTableUpdateCompanionBuilder,
          (
            InProgressGame,
            BaseReferences<
              _$AppDatabase,
              $InProgressGamesTable,
              InProgressGame
            >,
          ),
          InProgressGame,
          PrefetchHooks Function()
        > {
  $$InProgressGamesTableTableManager(
    _$AppDatabase db,
    $InProgressGamesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InProgressGamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InProgressGamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InProgressGamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> gridSize = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> givens = const Value.absent(),
                Value<String> values = const Value.absent(),
                Value<String> solution = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> hintedCells = const Value.absent(),
                Value<int?> selectedRow = const Value.absent(),
                Value<int?> selectedCol = const Value.absent(),
                Value<bool> notesMode = const Value.absent(),
                Value<int> mistakes = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
              }) => InProgressGamesCompanion(
                id: id,
                gridSize: gridSize,
                difficulty: difficulty,
                givens: givens,
                values: values,
                solution: solution,
                notes: notes,
                hintedCells: hintedCells,
                selectedRow: selectedRow,
                selectedCol: selectedCol,
                notesMode: notesMode,
                mistakes: mistakes,
                elapsedSeconds: elapsedSeconds,
                isComplete: isComplete,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int gridSize,
                Value<String> difficulty = const Value.absent(),
                required String givens,
                required String values,
                required String solution,
                required String notes,
                Value<String> hintedCells = const Value.absent(),
                Value<int?> selectedRow = const Value.absent(),
                Value<int?> selectedCol = const Value.absent(),
                Value<bool> notesMode = const Value.absent(),
                Value<int> mistakes = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
              }) => InProgressGamesCompanion.insert(
                id: id,
                gridSize: gridSize,
                difficulty: difficulty,
                givens: givens,
                values: values,
                solution: solution,
                notes: notes,
                hintedCells: hintedCells,
                selectedRow: selectedRow,
                selectedCol: selectedCol,
                notesMode: notesMode,
                mistakes: mistakes,
                elapsedSeconds: elapsedSeconds,
                isComplete: isComplete,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InProgressGamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InProgressGamesTable,
      InProgressGame,
      $$InProgressGamesTableFilterComposer,
      $$InProgressGamesTableOrderingComposer,
      $$InProgressGamesTableAnnotationComposer,
      $$InProgressGamesTableCreateCompanionBuilder,
      $$InProgressGamesTableUpdateCompanionBuilder,
      (
        InProgressGame,
        BaseReferences<_$AppDatabase, $InProgressGamesTable, InProgressGame>,
      ),
      InProgressGame,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PuzzlesTableTableManager get puzzles =>
      $$PuzzlesTableTableManager(_db, _db.puzzles);
  $$InProgressGamesTableTableManager get inProgressGames =>
      $$InProgressGamesTableTableManager(_db, _db.inProgressGames);
}
