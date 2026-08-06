/// Describes the box dimensions of a Sudoku grid. The grid is always
/// `size x size` where `size = boxW * boxH`, split into `size` boxes each
/// containing `boxW * boxH` cells.
class GridSpec {
  const GridSpec({required this.boxW, required this.boxH});

  final int boxW;
  final int boxH;

  int get size => boxW * boxH;
  int get cellCount => size * size;
  int get boxesPerRow => size ~/ boxW;

  int boxIndexOf(int row, int col) =>
      (row ~/ boxH) * boxesPerRow + (col ~/ boxW);

  static const size4 = GridSpec(boxW: 2, boxH: 2);
  static const size6 = GridSpec(boxW: 3, boxH: 2);
  static const size9 = GridSpec(boxW: 3, boxH: 3);
  static const size12 = GridSpec(boxW: 4, boxH: 3);
  static const size16 = GridSpec(boxW: 4, boxH: 4);

  static const all = [size4, size6, size9, size12, size16];

  @override
  bool operator ==(Object other) =>
      other is GridSpec && other.boxW == boxW && other.boxH == boxH;

  @override
  int get hashCode => Object.hash(boxW, boxH);

  @override
  String toString() => '${size}x$size';
}
