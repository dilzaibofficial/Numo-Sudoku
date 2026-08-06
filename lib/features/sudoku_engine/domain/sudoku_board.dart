import 'dart:typed_data';

import 'grid_spec.dart';

/// A flat, row-major board of cell values (0 = empty). Kept as a
/// [Uint8List] rather than nested lists so it's cheap to clone and to pass
/// across isolate boundaries.
class SudokuBoard {
  SudokuBoard(this.spec, this.cells)
      : assert(cells.length == spec.cellCount);

  factory SudokuBoard.empty(GridSpec spec) =>
      SudokuBoard(spec, Uint8List(spec.cellCount));

  final GridSpec spec;
  final Uint8List cells;

  int valueAt(int row, int col) => cells[row * spec.size + col];

  void setValue(int row, int col, int value) {
    cells[row * spec.size + col] = value;
  }

  int get filledCount => cells.where((v) => v != 0).length;

  bool get isComplete => !cells.contains(0);

  SudokuBoard clone() => SudokuBoard(spec, Uint8List.fromList(cells));

  /// True if [value] at (row, col) does not repeat within its row, column,
  /// or box. Ignores the cell at (row, col) itself so it can be used to
  /// check a value before or after placing it.
  bool isValuePlacementValid(int row, int col, int value) {
    final size = spec.size;
    for (var i = 0; i < size; i++) {
      if (i != col && valueAt(row, i) == value) return false;
      if (i != row && valueAt(i, col) == value) return false;
    }
    final boxRowStart = (row ~/ spec.boxH) * spec.boxH;
    final boxColStart = (col ~/ spec.boxW) * spec.boxW;
    for (var r = boxRowStart; r < boxRowStart + spec.boxH; r++) {
      for (var c = boxColStart; c < boxColStart + spec.boxW; c++) {
        if ((r != row || c != col) && valueAt(r, c) == value) return false;
      }
    }
    return true;
  }
}
