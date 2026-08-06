import 'package:flutter/material.dart';

import 'sudoku_board_colors.dart';

class AppTheme {
  AppTheme._();

  static const _seedColor = Color(0xFF3B6FE0);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      extensions: const [SudokuBoardColors.light],
    );
  }

  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0D1218),
      extensions: const [SudokuBoardColors.dark],
    );
  }
}

extension BuildContextTheme on BuildContext {
  SudokuBoardColors get boardColors =>
      Theme.of(this).extension<SudokuBoardColors>()!;
}
