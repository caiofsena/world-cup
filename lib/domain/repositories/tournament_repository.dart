import '../entities/team.dart';
import '../entities/match_entity.dart';
import '../entities/group_entity.dart';

abstract class TournamentRepository {
  Future<List<Team>> getTeams();
  Future<Team?> getTeamById(String id);
  Future<List<GroupEntity>> getGroups();
  Future<GroupEntity?> getGroupByLetter(String letter);
  Future<List<MatchEntity>> getMatches();
  Future<List<MatchEntity>> getMatchesByPhase(String phase);
  Future<List<MatchEntity>> getMatchesByGroup(String groupLetter);
  Future<MatchEntity?> getMatchById(int id);
  Future<List<MatchEntity>> getUpcomingMatches({int limit = 10});
  Future<List<GroupStanding>> calculateStandings(String groupLetter, List<MatchEntity> matches);
}
