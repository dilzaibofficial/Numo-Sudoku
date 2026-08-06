import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../sudoku_engine/domain/difficulty.dart';
import '../../sudoku_engine/domain/grid_spec.dart';

class NewGameArgs {
  const NewGameArgs({required this.spec, required this.difficulty});

  final GridSpec spec;
  final PuzzleDifficulty difficulty;
}

class NewGameScreen extends StatefulWidget {
  const NewGameScreen({super.key});

  @override
  State<NewGameScreen> createState() => _NewGameScreenState();
}

class _NewGameScreenState extends State<NewGameScreen> {
  GridSpec _spec = GridSpec.size9;
  PuzzleDifficulty _difficulty = PuzzleDifficulty.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Game')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Grid size', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final spec in GridSpec.all)
                    ChoiceChip(
                      label: Text(_sizeLabel(spec)),
                      selected: _spec == spec,
                      onSelected: (_) => setState(() => _spec = spec),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Text('Difficulty', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final difficulty in PuzzleDifficulty.values)
                    ChoiceChip(
                      label: Text(_difficultyLabel(difficulty)),
                      selected: _difficulty == difficulty,
                      onSelected: (_) => setState(() => _difficulty = difficulty),
                    ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () => context.push(
                    '/play',
                    extra: NewGameArgs(spec: _spec, difficulty: _difficulty),
                  ),
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _sizeLabel(GridSpec spec) {
    final base = '${spec.size}×${spec.size}';
    return spec.size == 9 ? '$base (Classic)' : base;
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
