import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../sudoku_engine/domain/difficulty.dart';
import '../../sudoku_engine/domain/grid_spec.dart';
import '../application/game_controller.dart';
import '../domain/game_board_state.dart';
import 'number_pad.dart';
import 'sudoku_board_widget.dart';

class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({
    super.key,
    this.spec = GridSpec.size9,
    this.difficulty = PuzzleDifficulty.normal,
  });

  final GridSpec spec;
  final PuzzleDifficulty difficulty;

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gameControllerProvider.notifier).startNewGame(widget.spec, widget.difficulty);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.spec} · ${_difficultyLabel(widget.difficulty)}'),
      ),
      body: state == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StatusBar(
                      mistakes: state.mistakes,
                      maxMistakes: GameBoardState.maxMistakes,
                      elapsed: state.elapsed,
                    ),
                    const SizedBox(height: 12),
                    SudokuBoardWidget(
                      state: state,
                      onCellTap: (row, col) =>
                          ref.read(gameControllerProvider.notifier).selectCell(row, col),
                    ),
                    const SizedBox(height: 16),
                    if (state.isComplete)
                      const _CompleteBanner()
                    else if (state.isGameOver)
                      const _GameOverBanner()
                    else ...[
                      _Toolbar(
                        notesMode: state.notesMode,
                        canUndo: state.canUndo,
                        onUndo: () => ref.read(gameControllerProvider.notifier).undo(),
                        onErase: () =>
                            ref.read(gameControllerProvider.notifier).clearSelectedCell(),
                        onToggleNotes: () =>
                            ref.read(gameControllerProvider.notifier).toggleNotesMode(),
                        onHint: () => ref.read(gameControllerProvider.notifier).useHint(),
                      ),
                      const SizedBox(height: 16),
                      NumberPad(
                        size: state.spec.size,
                        remainingCounts: _remainingCounts(state.spec.size, state.values),
                        onValueTap: (value) =>
                            ref.read(gameControllerProvider.notifier).enterValue(value),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  List<int> _remainingCounts(int size, List<int> values) {
    final placed = List<int>.filled(size, 0);
    for (final v in values) {
      if (v != 0) placed[v - 1]++;
    }
    return [for (var i = 0; i < size; i++) size - placed[i]];
  }

  String _difficultyLabel(PuzzleDifficulty difficulty) {
    switch (difficulty) {
      case PuzzleDifficulty.easy:
        return 'Easy';
      case PuzzleDifficulty.normal:
        return 'Normal';
      case PuzzleDifficulty.hard:
        return 'Hard';
      case PuzzleDifficulty.extraHard:
        return 'Extra Hard';
      case PuzzleDifficulty.expert:
        return 'Expert';
    }
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({
    required this.mistakes,
    required this.maxMistakes,
    required this.elapsed,
  });

  final int mistakes;
  final int maxMistakes;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Mistakes: $mistakes/$maxMistakes',
            style: Theme.of(context).textTheme.bodyLarge),
        Text('$minutes:$seconds', style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.notesMode,
    required this.canUndo,
    required this.onUndo,
    required this.onErase,
    required this.onToggleNotes,
    required this.onHint,
  });

  final bool notesMode;
  final bool canUndo;
  final VoidCallback onUndo;
  final VoidCallback onErase;
  final VoidCallback onToggleNotes;
  final VoidCallback onHint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ToolbarButton(icon: Icons.undo, label: 'Undo', onTap: canUndo ? onUndo : null),
        _ToolbarButton(icon: Icons.backspace_outlined, label: 'Erase', onTap: onErase),
        _ToolbarButton(
          icon: notesMode ? Icons.edit : Icons.edit_outlined,
          label: 'Notes',
          onTap: onToggleNotes,
          highlighted: notesMode,
        ),
        _ToolbarButton(icon: Icons.lightbulb_outline, label: 'Hint', onTap: onHint),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = onTap == null
        ? colorScheme.onSurface.withValues(alpha: 0.3)
        : (highlighted ? colorScheme.primary : colorScheme.onSurface);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _CompleteBanner extends StatelessWidget {
  const _CompleteBanner();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Puzzle solved!', textAlign: TextAlign.center),
      ),
    );
  }
}

class _GameOverBanner extends StatelessWidget {
  const _GameOverBanner();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Too many mistakes — try again', textAlign: TextAlign.center),
      ),
    );
  }
}
