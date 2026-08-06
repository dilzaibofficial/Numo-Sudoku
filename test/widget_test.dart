import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:numo_sudoku/main.dart';

void main() {
  testWidgets('App boots and shows the home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NumoSudokuApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Numo Sudoku'), findsWidgets);
  });

  testWidgets('Theme toggle switches between light and dark', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NumoSudokuApp()),
    );
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.system);

    await tester.tap(find.byIcon(Icons.dark_mode).first);
    await tester.pumpAndSettle();

    final updatedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(updatedApp.themeMode, ThemeMode.light);
  });
}
