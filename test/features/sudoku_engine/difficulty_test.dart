import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/difficulty.dart';

void main() {
  group('DifficultyTable', () {
    test('classifies 9x9 clue counts per the client-specified bands', () {
      expect(DifficultyTable.classify(81, 40), PuzzleDifficulty.easy);
      expect(DifficultyTable.classify(81, 33), PuzzleDifficulty.normal);
      expect(DifficultyTable.classify(81, 30), PuzzleDifficulty.hard);
      expect(DifficultyTable.classify(81, 25), PuzzleDifficulty.extraHard);
      expect(DifficultyTable.classify(81, 19), PuzzleDifficulty.expert);
    });

    test('returns null outside the defined 17-46 band for 9x9', () {
      expect(DifficultyTable.classify(81, 16), isNull);
      expect(DifficultyTable.classify(81, 47), isNull);
    });

    test('every supported grid size has all five difficulty bands defined', () {
      for (final cellCount in [16, 36, 81, 144, 256]) {
        for (final difficulty in PuzzleDifficulty.values) {
          expect(DifficultyTable.rangeFor(cellCount, difficulty), isNotNull,
              reason: 'missing $difficulty for $cellCount cells');
        }
      }
    });
  });
}
