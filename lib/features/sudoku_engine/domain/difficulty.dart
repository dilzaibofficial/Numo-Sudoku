enum PuzzleDifficulty { easy, normal, hard, extraHard, expert }

class ClueCountRange {
  const ClueCountRange(this.min, this.max);

  final int min;
  final int max;

  bool contains(int clueCount) => clueCount >= min && clueCount <= max;
}

/// Clue-count bands per grid cell-count, per the client's difficulty table
/// (calibrated for 9x9, scaled for the other sizes — tunable as real
/// generation/playtesting data comes in).
class DifficultyTable {
  DifficultyTable._();

  static const Map<int, Map<PuzzleDifficulty, ClueCountRange>> bySize = {
    16: {
      PuzzleDifficulty.easy: ClueCountRange(10, 12),
      PuzzleDifficulty.normal: ClueCountRange(8, 9),
      PuzzleDifficulty.hard: ClueCountRange(7, 7),
      PuzzleDifficulty.extraHard: ClueCountRange(6, 6),
      PuzzleDifficulty.expert: ClueCountRange(5, 5),
    },
    36: {
      PuzzleDifficulty.easy: ClueCountRange(20, 23),
      PuzzleDifficulty.normal: ClueCountRange(17, 19),
      PuzzleDifficulty.hard: ClueCountRange(15, 16),
      PuzzleDifficulty.extraHard: ClueCountRange(12, 14),
      PuzzleDifficulty.expert: ClueCountRange(9, 11),
    },
    81: {
      PuzzleDifficulty.easy: ClueCountRange(36, 46),
      PuzzleDifficulty.normal: ClueCountRange(32, 35),
      PuzzleDifficulty.hard: ClueCountRange(28, 31),
      PuzzleDifficulty.extraHard: ClueCountRange(22, 27),
      PuzzleDifficulty.expert: ClueCountRange(17, 21),
    },
    144: {
      PuzzleDifficulty.easy: ClueCountRange(70, 88),
      PuzzleDifficulty.normal: ClueCountRange(60, 68),
      PuzzleDifficulty.hard: ClueCountRange(52, 59),
      PuzzleDifficulty.extraHard: ClueCountRange(44, 51),
      PuzzleDifficulty.expert: ClueCountRange(36, 43),
    },
    256: {
      PuzzleDifficulty.easy: ClueCountRange(125, 150),
      PuzzleDifficulty.normal: ClueCountRange(105, 118),
      PuzzleDifficulty.hard: ClueCountRange(92, 104),
      PuzzleDifficulty.extraHard: ClueCountRange(78, 91),
      PuzzleDifficulty.expert: ClueCountRange(65, 77),
    },
  };

  static PuzzleDifficulty? classify(int cellCount, int clueCount) {
    final table = bySize[cellCount];
    if (table == null) return null;
    for (final entry in table.entries) {
      if (entry.value.contains(clueCount)) return entry.key;
    }
    return null;
  }

  static ClueCountRange? rangeFor(int cellCount, PuzzleDifficulty difficulty) =>
      bySize[cellCount]?[difficulty];
}
