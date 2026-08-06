import 'package:flutter/material.dart';

import '../../../app/theme/sudoku_board_colors.dart';
import '../domain/game_board_state.dart';

String glyphFor(int value) {
  if (value == 0) return '';
  if (value <= 9) return '$value';
  return String.fromCharCode(55 + value); // 10->A, 11->B, ... 16->G
}

class SudokuBoardPainter extends CustomPainter {
  SudokuBoardPainter({
    required this.state,
    required this.colors,
    required this.textColor,
  });

  final GameBoardState state;
  final SudokuBoardColors colors;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final spec = state.spec;
    final cellSize = size.width / spec.size;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = colors.boardBackground,
    );

    _paintHighlights(canvas, cellSize);
    _paintGridLines(canvas, size, cellSize);
    _paintContent(canvas, cellSize);
  }

  void _paintHighlights(Canvas canvas, double cellSize) {
    final spec = state.spec;
    final selRow = state.selectedRow;
    final selCol = state.selectedCol;
    if (selRow == null || selCol == null) return;

    final selectedValue = state.values[state.cellIndex(selRow, selCol)];

    for (var r = 0; r < spec.size; r++) {
      for (var c = 0; c < spec.size; c++) {
        final isSelected = r == selRow && c == selCol;
        final isRelated = !isSelected &&
            (r == selRow ||
                c == selCol ||
                spec.boxIndexOf(r, c) == spec.boxIndexOf(selRow, selCol));
        final isSameValue = !isSelected &&
            selectedValue != 0 &&
            state.values[state.cellIndex(r, c)] == selectedValue;

        Color? fill;
        if (isSelected) {
          fill = colors.selectedCell;
        } else if (isSameValue) {
          fill = colors.sameValueCell;
        } else if (isRelated) {
          fill = colors.relatedCell;
        }
        if (fill == null) continue;

        canvas.drawRect(
          Rect.fromLTWH(c * cellSize, r * cellSize, cellSize, cellSize),
          Paint()..color = fill,
        );
      }
    }
  }

  void _paintGridLines(Canvas canvas, Size size, double cellSize) {
    final spec = state.spec;
    final thinPaint = Paint()
      ..color = colors.thinGridLine
      ..strokeWidth = 1;
    final thickPaint = Paint()
      ..color = colors.thickGridLine
      ..strokeWidth = 2.5;

    for (var i = 0; i <= spec.size; i++) {
      final isBoxEdgeV = i % spec.boxW == 0;
      final paintV = isBoxEdgeV ? thickPaint : thinPaint;
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        paintV,
      );

      final isBoxEdgeH = i % spec.boxH == 0;
      final paintH = isBoxEdgeH ? thickPaint : thinPaint;
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        paintH,
      );
    }
  }

  void _paintContent(Canvas canvas, double cellSize) {
    final spec = state.spec;
    final numberFontSize = cellSize * 0.5;
    final noteFontSize = cellSize / spec.boxW * 0.32;

    for (var r = 0; r < spec.size; r++) {
      for (var c = 0; c < spec.size; c++) {
        final index = state.cellIndex(r, c);
        final value = state.values[index];
        final origin = Offset(c * cellSize, r * cellSize);

        if (value != 0) {
          final isGiven = state.givens[index] != 0;
          final isError = !isGiven && state.solution[index] != value;
          final color = isGiven
              ? colors.givenNumber
              : (isError ? colors.errorNumber : colors.userNumber);
          _paintCenteredText(
            canvas,
            glyphFor(value),
            origin,
            cellSize,
            color,
            numberFontSize,
            FontWeight.w600,
          );
        } else if (state.notes[index].isNotEmpty) {
          _paintNotes(canvas, state.notes[index], origin, cellSize, noteFontSize);
        }
      }
    }
  }

  void _paintCenteredText(
    Canvas canvas,
    String text,
    Offset cellOrigin,
    double cellSize,
    Color color,
    double fontSize,
    FontWeight weight,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      cellOrigin +
          Offset(
            (cellSize - painter.width) / 2,
            (cellSize - painter.height) / 2,
          ),
    );
  }

  void _paintNotes(
    Canvas canvas,
    Set<int> notes,
    Offset cellOrigin,
    double cellSize,
    double fontSize,
  ) {
    final spec = state.spec;
    final subCols = spec.boxW;
    final subRows = spec.boxH;
    final subCellSize = cellSize / (subCols > subRows ? subCols : subRows);

    for (final value in notes) {
      final i = value - 1;
      final row = i ~/ subCols;
      final col = i % subCols;
      final subOrigin = cellOrigin + Offset(col * subCellSize, row * subCellSize);
      _paintCenteredText(
        canvas,
        glyphFor(value),
        subOrigin,
        subCellSize,
        colors.noteText,
        fontSize,
        FontWeight.normal,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SudokuBoardPainter oldDelegate) {
    return oldDelegate.state != state || oldDelegate.colors != colors;
  }
}
