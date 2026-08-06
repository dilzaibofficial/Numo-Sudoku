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
          _NumberButton(
            label: glyphFor(value),
            remaining: remainingCounts[value - 1],
            onTap: remainingCounts[value - 1] > 0 ? () => onValueTap(value) : null,
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
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: enabled ? colorScheme.surfaceContainerHigh : Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: enabled
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
