import 'package:flutter_test/flutter_test.dart';
import 'package:numo_sudoku/features/sudoku_engine/domain/grid_spec.dart';

void main() {
  group('GridSpec', () {
    test('size and cellCount are derived from box dimensions', () {
      expect(GridSpec.size4.size, 4);
      expect(GridSpec.size4.cellCount, 16);
      expect(GridSpec.size6.size, 6);
      expect(GridSpec.size6.cellCount, 36);
      expect(GridSpec.size9.size, 9);
      expect(GridSpec.size9.cellCount, 81);
      expect(GridSpec.size12.size, 12);
      expect(GridSpec.size12.cellCount, 144);
      expect(GridSpec.size16.size, 16);
      expect(GridSpec.size16.cellCount, 256);
    });

    test('boxIndexOf covers every box exactly size/box times for 9x9', () {
      const spec = GridSpec.size9;
      final counts = List<int>.filled(spec.size, 0);
      for (var r = 0; r < spec.size; r++) {
        for (var c = 0; c < spec.size; c++) {
          counts[spec.boxIndexOf(r, c)]++;
        }
      }
      // Every one of the 9 boxes should be hit by exactly 9 cells.
      expect(counts, List<int>.filled(9, 9));
    });

    test('boxIndexOf covers every box for a non-square box shape (6x6)', () {
      const spec = GridSpec.size6; // 3-wide x 2-tall boxes
      final counts = List<int>.filled(spec.size, 0);
      for (var r = 0; r < spec.size; r++) {
        for (var c = 0; c < spec.size; c++) {
          final b = spec.boxIndexOf(r, c);
          expect(b, inInclusiveRange(0, spec.size - 1));
          counts[b]++;
        }
      }
      expect(counts, List<int>.filled(6, 6));
    });

    test('boxIndexOf covers every box for all five supported sizes', () {
      for (final spec in GridSpec.all) {
        final counts = List<int>.filled(spec.size, 0);
        for (var r = 0; r < spec.size; r++) {
          for (var c = 0; c < spec.size; c++) {
            counts[spec.boxIndexOf(r, c)]++;
          }
        }
        expect(counts, List<int>.filled(spec.size, spec.size),
            reason: 'failed for $spec');
      }
    });
  });
}
