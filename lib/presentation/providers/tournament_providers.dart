import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/tournament_local_datasource.dart';
import '../../data/repositories/tournament_repository_impl.dart';
import '../../domain/entities/team.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/group_entity.dart';

final tournamentDatasourceProvider = Provider(
  (ref) => TournamentLocalDatasource(),
);

final tournamentRepositoryProvider = Provider(
  (ref) => TournamentRepositoryImpl(
    ref.watch(tournamentDatasourceProvider),
  ),
);

final teamsProvider = FutureProvider<List<Team>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTeams();
});

final teamByIdProvider = FutureProvider.family<Team?, String>(
  (ref, id) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    return repo.getTeamById(id);
  },
);

final groupsProvider = FutureProvider<List<GroupEntity>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getGroups();
});

final groupByLetterProvider = FutureProvider.family<GroupEntity?, String>(
  (ref, letter) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    return repo.getGroupByLetter(letter);
  },
);

final matchesProvider = FutureProvider<List<MatchEntity>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getMatches();
});

final matchesByPhaseProvider = FutureProvider.family<List<MatchEntity>, String>(
  (ref, phase) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    return repo.getMatchesByPhase(phase);
  },
);

final matchesByGroupProvider =
    FutureProvider.family<List<MatchEntity>, String>(
  (ref, groupLetter) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    return repo.getMatchesByGroup(groupLetter);
  },
);

final matchByIdProvider = FutureProvider.family<MatchEntity?, int>(
  (ref, id) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    return repo.getMatchById(id);
  },
);

final upcomingMatchesProvider = FutureProvider<List<MatchEntity>>((ref) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getUpcomingMatches(limit: 10);
});

final standingsProvider =
    FutureProvider.family<List<GroupStanding>, String>(
  (ref, groupLetter) async {
    final repo = ref.watch(tournamentRepositoryProvider);
    final matches = await repo.getMatches();
    return repo.calculateStandings(groupLetter, matches);
  },
);
