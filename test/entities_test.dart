import 'package:flutter_test/flutter_test.dart';
import 'package:world_cup_2026/domain/entities/team.dart';
import 'package:world_cup_2026/domain/entities/match_entity.dart';
import 'package:world_cup_2026/domain/entities/group_entity.dart';
import 'package:world_cup_2026/data/repositories/tournament_repository_impl.dart';

void main() {
  group('Team', () {
    test('should create from json', () {
      final json = {
        'id': 'bra',
        'name': 'Brasil',
        'fifaCode': 'BRA',
        'flagCode': 'br',
      };
      final team = Team.fromJson(json);
      expect(team.id, 'bra');
      expect(team.name, 'Brasil');
      expect(team.fifaCode, 'BRA');
      expect(team.flagCode, 'br');
      expect(team.flagUrl, contains('flagcdn.com'));
    });

    test('should serialize to json', () {
      final team = Team(
        id: 'bra',
        name: 'Brasil',
        fifaCode: 'BRA',
        flagCode: 'br',
      );
      final json = team.toJson();
      expect(json['id'], 'bra');
      expect(json['name'], 'Brasil');
    });
  });

  group('MatchEntity', () {
    test('should report unplayed status', () {
      final match = MatchEntity(
        id: 1,
        phase: 'group',
        group: 'A',
        homeTeamId: 'mex',
        awayTeamId: 'rsa',
        date: DateTime(2026, 6, 11),
        stadium: 'Azteca',
        city: 'Cidade do México',
      );
      expect(match.isPlayed, false);
      expect(match.result, 'vs');
    });
  });

  group('GroupStanding', () {
    test('should calculate points correctly', () {
      final standing = GroupStanding(
        teamId: 'bra',
        won: 2,
        drawn: 1,
        lost: 0,
        goalsFor: 5,
        goalsAgainst: 1,
      );
      expect(standing.points, 7);
      expect(standing.goalDifference, 4);
    });
  });
}
