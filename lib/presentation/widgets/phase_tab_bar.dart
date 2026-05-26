import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class PhaseTabBar extends StatelessWidget {
  final String selectedPhase;
  final ValueChanged<String> onPhaseChanged;
  final bool showAllPhases;

  const PhaseTabBar({
    required this.selectedPhase,
    required this.onPhaseChanged,
    this.showAllPhases = false,
  });

  @override
  Widget build(BuildContext context) {
    final phases = showAllPhases
        ? AppConstants.phases
        : ['group', 'round32', 'round16', 'quarter', 'semi', 'thirdPlace', 'final'];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: phases.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final phase = phases[index];
          final isSelected = selectedPhase == phase;
          final label = AppConstants.phaseLabels[phase] ?? phase;

          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onPhaseChanged(phase),
            labelStyle: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : null,
            ),
            selectedColor: Theme.of(context).colorScheme.primary,
            checkmarkColor: Colors.white,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
