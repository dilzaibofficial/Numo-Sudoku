import 'package:flutter/material.dart';

import 'sudoku_board_painter.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.size,
    required this.remainingCounts,
    required this.onValueTap,
  });

  final int size;
  final List<int> remainingCounts;
  final void Function(int value) onValueTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var value = 1; value <= size; value++)
          if (remainingCounts[value - 1] > 0)
            _NumberButton(
              label: glyphFor(value),
              remaining: remainingCounts[value - 1],
              onTap: () => onValueTap(value),
            ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    required this.label,
    required this.remaining,
    required this.onTap,
  });

  final String label;
  final int remaining;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 44,
      height: 52,
      child: Material(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                '$remaining',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
