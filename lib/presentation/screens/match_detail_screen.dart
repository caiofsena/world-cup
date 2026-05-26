import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/tournament_providers.dart';
import '../providers/prediction_providers.dart';
import '../providers/auth_providers.dart';
import '../widgets/team_flag.dart';
import '../widgets/prediction_input.dart';

class MatchDetailScreen extends ConsumerWidget {
  final int matchId;

  const MatchDetailScreen({required this.matchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchByIdProvider(matchId));
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Jogo')),
      body: matchAsync.when(
        data: (match) {
          if (match == null) {
            return const Center(child: Text('Jogo nao encontrado'));
          }

          final homeTeamAsync = ref.watch(teamByIdProvider(match.homeTeamId));
          final awayTeamAsync = ref.watch(teamByIdProvider(match.awayTeamId));
          final predictionAsync = ref.watch(predictionByMatchProvider(matchId));

          final homeTeam = homeTeamAsync.valueOrNull;
          final awayTeam = awayTeamAsync.valueOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                _buildPhaseBadge(context, match.phase),
                if (match.group != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Grupo ${match.group}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _TeamInfo(
                        team: homeTeam,
                        flagCode: match.homeTeamId,
                        isHome: true,
                      ),
                    ),
                    _buildScoreOrVs(match),
                    Expanded(
                      child: _TeamInfo(
                        team: awayTeam,
                        flagCode: match.awayTeamId,
                        isHome: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                _buildMatchInfo(match),
                const SizedBox(height: 16),

                Text(
                  match.stadium,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  match.city,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[500],
                  ),
                ),

                if (user != null && !match.isPlayed) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  predictionAsync.when(
                    data: (prediction) => PredictionInput(
                      homeGoals: prediction?.homeGoals,
                      awayGoals: prediction?.awayGoals,
                      onSave: (result) {
                        final (home, away) = result;
                        ref.read(savePredictionProvider.notifier).save(
                              user.uid,
                              matchId,
                              home,
                              away,
                            );
                        ref.invalidate(predictionByMatchProvider(matchId));
                        ref.invalidate(userPredictionsProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Palpite salvo com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Text('Erro: $e'),
                  ),
                ],

                if (user != null && match.isPlayed) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  predictionAsync.when(
                    data: (prediction) {
                      if (prediction == null) {
                        return Card(
                          margin: EdgeInsets.zero,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Voce nao fez palpite para este jogo.',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      }
                      return _buildPredictionResult(prediction, match);
                    },
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],

                if (user == null) ...[
                  const SizedBox(height: 24),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline,
                              size: 32, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Faca login para registrar seus palpites',
                            style: TextStyle(color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
      ),
    );
  }

  Widget _buildPhaseBadge(BuildContext context, String phase) {
    final labels = {
      'group': 'Fase de Grupos',
      'round32': '16-avos de Final',
      'round16': 'Oitavas de Final',
      'quarter': 'Quartas de Final',
      'semi': 'Semifinal',
      'thirdPlace': 'Disputa de 3º Lugar',
      'final': 'Final',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        labels[phase] ?? phase,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildScoreOrVs(match) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: match.isPlayed
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${match.homeGoals}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ),
                Text(
                  '${match.awayGoals}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'VS',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 2,
                ),
              ),
            ),
    );
  }

  Widget _buildMatchInfo(match) {
    final dateStr =
        '${match.date.day.toString().padLeft(2, '0')}/${match.date.month.toString().padLeft(2, '0')}/${match.date.year}';
    final timeStr =
        '${match.date.hour.toString().padLeft(2, '0')}:${match.date.minute.toString().padLeft(2, '0')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(dateStr, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(width: 12),
        const Icon(Icons.access_time, size: 14, color: Colors.grey),
        const SizedBox(width: 4),
        Text(timeStr, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ],
    );
  }

  Widget _buildPredictionResult(prediction, match) {
    final predictedResult = '${prediction.homeGoals} x ${prediction.awayGoals}';
    final actualResult = '${match.homeGoals} x ${match.awayGoals}';

    final isExactMatch = prediction.homeGoals == match.homeGoals &&
        prediction.awayGoals == match.awayGoals;
    final isCorrectResult =
        (prediction.homeGoals > prediction.awayGoals &&
                match.homeGoals > match.awayGoals) ||
            (prediction.homeGoals < prediction.awayGoals &&
                match.homeGoals < match.awayGoals) ||
            (prediction.homeGoals == prediction.awayGoals &&
                match.homeGoals == match.awayGoals);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isExactMatch
                      ? Icons.star
                      : isCorrectResult
                          ? Icons.check_circle
                          : Icons.cancel,
                  color: isExactMatch
                      ? Colors.amber
                      : isCorrectResult
                          ? Colors.green
                          : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Seu palpite: $predictedResult',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Resultado real: $actualResult',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final dynamic team;
  final String flagCode;
  final bool isHome;

  const _TeamInfo({
    required this.team,
    required this.flagCode,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamFlag(
          flagCode: flagCode,
          size: 48,
          teamName: team?.name,
        ),
        const SizedBox(height: 8),
        Text(
          team?.name ?? flagCode.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
