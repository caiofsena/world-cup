import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/match_entity.dart';
import '../providers/tournament_providers.dart';
import 'team_flag.dart';

class MatchCard extends ConsumerWidget {
  final MatchEntity match;
  final VoidCallback? onTap;

  const MatchCard({
    required this.match,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeTeamAsync = ref.watch(teamByIdProvider(match.homeTeamId));
    final awayTeamAsync = ref.watch(teamByIdProvider(match.awayTeamId));

    final homeTeam = homeTeamAsync.valueOrNull;
    final awayTeam = awayTeamAsync.valueOrNull;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (homeTeam != null)
                          TeamFlag(
                            flagCode: homeTeam.flagCode,
                            teamName: homeTeam.name,
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            homeTeam?.name ?? match.homeTeamId.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          match.isPlayed
                              ? '${match.homeGoals}'
                              : '-',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: match.isPlayed ? null : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (awayTeam != null)
                          TeamFlag(
                            flagCode: awayTeam.flagCode,
                            teamName: awayTeam.name,
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            awayTeam?.name ?? match.awayTeamId.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          match.isPlayed
                              ? '${match.awayGoals}'
                              : '-',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: match.isPlayed ? null : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(match.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(match.date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.city,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'jan', 'fev', 'mar', 'abr', 'mai', 'jun',
      'jul', 'ago', 'set', 'out', 'nov', 'dez',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
