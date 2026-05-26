import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/match_entity.dart';
import '../providers/tournament_providers.dart';
import '../widgets/match_card.dart';
import '../widgets/phase_tab_bar.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen();

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen> {
  String _selectedPhase = 'group';

  @override
  Widget build(BuildContext context) {
    final matchesAsync = ref.watch(matchesByPhaseProvider(_selectedPhase));

    return Scaffold(
      appBar: AppBar(title: const Text('Jogos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: PhaseTabBar(
              selectedPhase: _selectedPhase,
              onPhaseChanged: (phase) {
                setState(() => _selectedPhase = phase);
              },
              showAllPhases: true,
            ),
          ),
          Expanded(
            child: matchesAsync.when(
              data: (matches) {
                if (matches.isEmpty) {
                  return const Center(
                    child: Text('Nenhum jogo nesta fase'),
                  );
                }

                final groupedMatches = _groupMatchesByDate(matches);

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: groupedMatches.length,
                  itemBuilder: (context, index) {
                    final entry = groupedMatches.entries.elementAt(index);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(
                            _formatDateHeader(entry.key),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        ...entry.value.map(
                          (match) => MatchCard(
                            match: match,
                            onTap: () => context.push('/matches/${match.id}'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erro ao carregar jogos: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(
                        matchesByPhaseProvider(_selectedPhase).future,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<MatchEntity>> _groupMatchesByDate(List<MatchEntity> matches) {
    final grouped = <DateTime, List<MatchEntity>>{};
    for (final match in matches) {
      final date = DateTime(match.date.year, match.date.month, match.date.day);
      grouped.putIfAbsent(date, () => []).add(match);
    }
    return Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  String _formatDateHeader(DateTime date) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro',
    ];
    const weekdays = [
      'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo',
    ];
    final wd = weekdays[date.weekday - 1];
    return '$wd, ${date.day} de ${months[date.month - 1]}';
  }
}
