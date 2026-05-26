import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/group_entity.dart';
import '../providers/tournament_providers.dart';
import '../widgets/match_card.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupLetter;

  const GroupDetailScreen({required this.groupLetter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupByLetterProvider(groupLetter));
    final standingsAsync = ref.watch(standingsProvider(groupLetter));
    final matchesAsync = ref.watch(matchesByGroupProvider(groupLetter));
    final teamsAsync = ref.watch(teamsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Grupo $groupLetter')),
      body: groupAsync.when(
        data: (group) {
          if (group == null) {
            return const Center(child: Text('Grupo nao encontrado'));
          }

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Classificacao'),
                    Tab(text: 'Jogos'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildStandings(context, ref, standingsAsync, teamsAsync, group),
                      _buildMatches(context, matchesAsync),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  Widget _buildStandings(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<GroupStanding>> standingsAsync,
    AsyncValue<List> teamsAsync,
    GroupEntity group,
  ) {
    return standingsAsync.when(
      data: (standings) {
        final teams = teamsAsync.valueOrNull ?? <Team>[];

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: standings.length + 1,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildHeader(),
              );
            }

            final standing = standings[index - 1];
            Team? team;
            try {
              team = teams.firstWhere((t) => t.id == standing.teamId);
            } catch (_) {
              team = null;
            }

            final isAdvancing = index <= 2;
            final isThirdPlace = index == 3;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: isAdvancing
                  ? Colors.green[50]
                  : isThirdPlace
                      ? Colors.orange[50]
                      : null,
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    child: Text(
                      '$index',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAdvancing
                            ? Colors.green[700]
                            : isThirdPlace
                                ? Colors.orange[700]
                                : Colors.grey,
                      ),
                    ),
                  ),
                  if (team != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.network(
                        'https://flagcdn.com/w40/${team.flagCode.toLowerCase()}.png',
                        width: 22,
                        height: 15,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(width: 22, height: 15),
                      ),
                    ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      team?.name ?? standing.teamId.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _dataCell('${standing.points}', bold: true),
                  _dataCell('${standing.played}'),
                  _dataCell('${standing.won}'),
                  _dataCell('${standing.drawn}'),
                  _dataCell('${standing.lost}'),
                  _dataCell('${standing.goalsFor}'),
                  _dataCell('${standing.goalsAgainst}'),
                  _dataCell('${standing.goalDifference}'),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const SizedBox(width: 32),
        const Expanded(
          flex: 2,
          child: Text(
            'Time',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _headerCell('P'),
        _headerCell('J'),
        _headerCell('V'),
        _headerCell('E'),
        _headerCell('D'),
        _headerCell('GP'),
        _headerCell('GC'),
        _headerCell('SG'),
      ],
    );
  }

  Widget _headerCell(String text) => SizedBox(
        width: 28,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  Widget _dataCell(String text, {bool bold = false}) => SizedBox(
        width: 28,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

  Widget _buildMatches(
    BuildContext context,
    AsyncValue<List> matchesAsync,
  ) {
    return matchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          return const Center(child: Text('Nenhum jogo encontrado'));
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(match: match, onTap: () {});
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erro: $e')),
    );
  }
}
