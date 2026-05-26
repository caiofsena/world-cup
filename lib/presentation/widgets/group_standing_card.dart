import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/group_entity.dart';
import '../providers/tournament_providers.dart';
import 'team_flag.dart';

class GroupStandingCard extends ConsumerWidget {
  final String groupLetter;
  final VoidCallback? onTap;

  const GroupStandingCard({
    required this.groupLetter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(standingsProvider(groupLetter));
    final teamsAsync = ref.watch(teamsProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Grupo $groupLetter',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              const _StandingHeader(),
              const Divider(height: 8),
              standingsAsync.when(
                data: (standings) {
                  final teams = teamsAsync.valueOrNull ?? <Team>[];
                  final displayStandings = standings.take(4).toList();

                  return Column(
                    children: displayStandings.map((standing) {
                      Team? team;
                      try {
                        team = teams.firstWhere(
                          (t) => t.id == standing.teamId,
                        );
                      } catch (_) {
                        team = null;
                      }
                      return _StandingRow(
                        position: displayStandings.indexOf(standing) + 1,
                        teamName: team?.name ?? standing.teamId.toUpperCase(),
                        flagCode: team?.flagCode ?? standing.teamId,
                        points: standing.points,
                        played: standing.played,
                        won: standing.won,
                        drawn: standing.drawn,
                        lost: standing.lost,
                        goalsFor: standing.goalsFor,
                        goalsAgainst: standing.goalsAgainst,
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text('Erro: $e'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StandingHeader extends StatelessWidget {
  const _StandingHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 28),
        const Expanded(child: Text('Time', style: TextStyle(fontSize: 11, color: Colors.grey))),
        const SizedBox(width: 4),
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
        width: 24,
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      );
}

class _StandingRow extends StatelessWidget {
  final int position;
  final String teamName;
  final String flagCode;
  final int points, played, won, drawn, lost, goalsFor, goalsAgainst;

  const _StandingRow({
    required this.position,
    required this.teamName,
    required this.flagCode,
    required this.points,
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
  });

  @override
  Widget build(BuildContext context) {
    final isAdvancing = position <= 2;
    final isThirdPlace = position == 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isAdvancing
                    ? Colors.green[100]
                    : isThirdPlace
                        ? Colors.orange[100]
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  '$position',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isAdvancing
                        ? Colors.green[700]
                        : isThirdPlace
                            ? Colors.orange[700]
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          TeamFlag(flagCode: flagCode, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              teamName,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _dataCell(points.toString(), bold: true),
          _dataCell(played.toString()),
          _dataCell(won.toString()),
          _dataCell(drawn.toString()),
          _dataCell(lost.toString()),
          _dataCell(goalsFor.toString()),
          _dataCell(goalsAgainst.toString()),
          _dataCell((goalsFor - goalsAgainst).toString()),
        ],
      ),
    );
  }

  Widget _dataCell(String text, {bool bold = false}) => SizedBox(
        width: 22,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
}
