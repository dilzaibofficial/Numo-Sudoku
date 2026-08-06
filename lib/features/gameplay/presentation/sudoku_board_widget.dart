import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../domain/game_board_state.dart';
import 'sudoku_board_painter.dart';

class SudokuBoardWidget extends StatelessWidget {
  const SudokuBoardWidget({
    super.key,
    required this.state,
    required this.onCellTap,
  });

  final GameBoardState state;
  final void Function(int row, int col) onCellTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.boardColors;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth / state.spec.size;
          return GestureDetector(
            onTapDown: (details) {
              final col = (details.localPosition.dx / cellSize)
                  .floor()
                  .clamp(0, state.spec.size - 1);
              final row = (details.localPosition.dy / cellSize)
                  .floor()
                  .clamp(0, state.spec.size - 1);
              onCellTap(row, col);
            },
            child: CustomPaint(
              size: Size.square(constraints.maxWidth),
              painter: SudokuBoardPainter(
                state: state,
                colors: colors,
                textColor: textColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
