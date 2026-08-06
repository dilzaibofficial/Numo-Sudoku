import 'package:flutter/material.dart';

@immutable
class SudokuBoardColors extends ThemeExtension<SudokuBoardColors> {
  const SudokuBoardColors({
    required this.boardBackground,
    required this.cellBackground,
    required this.selectedCell,
    required this.relatedCell,
    required this.sameValueCell,
    required this.thinGridLine,
    required this.thickGridLine,
    required this.givenNumber,
    required this.userNumber,
    required this.errorNumber,
    required this.noteText,
  });

  final Color boardBackground;
  final Color cellBackground;
  final Color selectedCell;
  final Color relatedCell;
  final Color sameValueCell;
  final Color thinGridLine;
  final Color thickGridLine;
  final Color givenNumber;
  final Color userNumber;
  final Color errorNumber;
  final Color noteText;

  static const light = SudokuBoardColors(
    boardBackground: Color(0xFFFFFFFF),
    cellBackground: Color(0xFFFFFFFF),
    selectedCell: Color(0xFFBBD6FB),
    relatedCell: Color(0xFFE8EEF9),
    sameValueCell: Color(0xFFD3E3FD),
    thinGridLine: Color(0xFFC7CDD6),
    thickGridLine: Color(0xFF33404F),
    givenNumber: Color(0xFF1F2937),
    userNumber: Color(0xFF3B6FE0),
    errorNumber: Color(0xFFE5484D),
    noteText: Color(0xFF6B7280),
  );

  static const dark = SudokuBoardColors(
    boardBackground: Color(0xFF121821),
    cellBackground: Color(0xFF121821),
    selectedCell: Color(0xFF2C4870),
    relatedCell: Color(0xFF1C2733),
    sameValueCell: Color(0xFF25405F),
    thinGridLine: Color(0xFF39424E),
    thickGridLine: Color(0xFF8B96A5),
    givenNumber: Color(0xFFE5E9F0),
    userNumber: Color(0xFF7EA6FA),
    errorNumber: Color(0xFFFF6B6B),
    noteText: Color(0xFF8B96A5),
  );

  @override
  SudokuBoardColors copyWith({
    Color? boardBackground,
    Color? cellBackground,
    Color? selectedCell,
    Color? relatedCell,
    Color? sameValueCell,
    Color? thinGridLine,
    Color? thickGridLine,
    Color? givenNumber,
    Color? userNumber,
    Color? errorNumber,
    Color? noteText,
  }) {
    return SudokuBoardColors(
      boardBackground: boardBackground ?? this.boardBackground,
      cellBackground: cellBackground ?? this.cellBackground,
      selectedCell: selectedCell ?? this.selectedCell,
      relatedCell: relatedCell ?? this.relatedCell,
      sameValueCell: sameValueCell ?? this.sameValueCell,
      thinGridLine: thinGridLine ?? this.thinGridLine,
      thickGridLine: thickGridLine ?? this.thickGridLine,
      givenNumber: givenNumber ?? this.givenNumber,
      userNumber: userNumber ?? this.userNumber,
      errorNumber: errorNumber ?? this.errorNumber,
      noteText: noteText ?? this.noteText,
    );
  }

  @override
  SudokuBoardColors lerp(ThemeExtension<SudokuBoardColors>? other, double t) {
    if (other is! SudokuBoardColors) return this;
    return SudokuBoardColors(
      boardBackground: Color.lerp(boardBackground, other.boardBackground, t)!,
      cellBackground: Color.lerp(cellBackground, other.cellBackground, t)!,
      selectedCell: Color.lerp(selectedCell, other.selectedCell, t)!,
      relatedCell: Color.lerp(relatedCell, other.relatedCell, t)!,
      sameValueCell: Color.lerp(sameValueCell, other.sameValueCell, t)!,
      thinGridLine: Color.lerp(thinGridLine, other.thinGridLine, t)!,
      thickGridLine: Color.lerp(thickGridLine, other.thickGridLine, t)!,
      givenNumber: Color.lerp(givenNumber, other.givenNumber, t)!,
      userNumber: Color.lerp(userNumber, other.userNumber, t)!,
      errorNumber: Color.lerp(errorNumber, other.errorNumber, t)!,
      noteText: Color.lerp(noteText, other.noteText, t)!,
    );
  }
}
