import '../../domain/entities/team.dart';
import '../../domain/entities/match_entity.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repositories/tournament_repository.dart';
import '../datasources/tournament_local_datasource.dart';

class TournamentRepositoryImpl implements TournamentRepository {
  final TournamentLocalDatasource _datasource;

  TournamentRepositoryImpl(this._datasource);

  @override
  Future<List<Team>> getTeams() => _datasource.getTeams();

  @override
  Future<Team?> getTeamById(String id) async {
    final teams = await _datasource.getTeams();
    try {
      return teams.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<GroupEntity>> getGroups() => _datasource.getGroups();

  @override
  Future<GroupEntity?> getGroupByLetter(String letter) async {
    final groups = await _datasource.getGroups();
    try {
      return groups.firstWhere((g) => g.letter == letter);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MatchEntity>> getMatches() => _datasource.getMatches();

  @override
  Future<List<MatchEntity>> getMatchesByPhase(String phase) async {
    final matches = await _datasource.getMatches();
    return matches.where((m) => m.phase == phase).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<List<MatchEntity>> getMatchesByGroup(String groupLetter) async {
    final matches = await _datasource.getMatches();
    return matches.where((m) => m.group == groupLetter).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Future<MatchEntity?> getMatchById(int id) async {
    final matches = await _datasource.getMatches();
    try {
      return matches.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MatchEntity>> getUpcomingMatches({int limit = 10}) async {
    final matches = await _datasource.getMatches();
    final now = DateTime.now();
    final upcoming = matches
        .where((m) => m.date.isAfter(now) && !m.isPlayed)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return upcoming.take(limit).toList();
  }

  @override
  Future<List<GroupStanding>> calculateStandings(
      String groupLetter, List<MatchEntity> matches) async {
    final groupMatches = matches.where((m) => m.group == groupLetter && m.isPlayed);
    final teams = (await getGroupByLetter(groupLetter))?.teamIds ?? [];

    final standings = <String, GroupStanding>{};
    for (final teamId in teams) {
      standings[teamId] = GroupStanding(teamId: teamId);
    }

    for (final match in groupMatches) {
      if (!match.isPlayed) continue;

      final home = standings[match.homeTeamId]!;
      final away = standings[match.awayTeamId]!;

      home.played++;
      away.played++;
      home.goalsFor += match.homeGoals!;
      home.goalsAgainst += match.awayGoals!;
      away.goalsFor += match.awayGoals!;
      away.goalsAgainst += match.homeGoals!;

      if (match.homeGoals! > match.awayGoals!) {
        home.won++;
        away.lost++;
      } else if (match.homeGoals! < match.awayGoals!) {
        away.won++;
        home.lost++;
      } else {
        home.drawn++;
        away.drawn++;
      }
    }

    final sorted = standings.values.toList()
      ..sort((a, b) {
        final ptDiff = b.points.compareTo(a.points);
        if (ptDiff != 0) return ptDiff;
        final gdDiff = b.goalDifference.compareTo(a.goalDifference);
        if (gdDiff != 0) return gdDiff;
        return b.goalsFor.compareTo(a.goalsFor);
      });

    return sorted;
  }
}
