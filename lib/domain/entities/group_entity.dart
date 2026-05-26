import 'team.dart';

class GroupStanding {
  final String teamId;
  int played;
  int won;
  int drawn;
  int lost;
  int goalsFor;
  int goalsAgainst;

  GroupStanding({
    required this.teamId,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
  });

  int get points => won * 3 + drawn;
  int get goalDifference => goalsFor - goalsAgainst;

  Map<String, dynamic> toJson() => {
        'teamId': teamId,
        'played': played,
        'won': won,
        'drawn': drawn,
        'lost': lost,
        'goalsFor': goalsFor,
        'goalsAgainst': goalsAgainst,
      };

  factory GroupStanding.fromJson(Map<String, dynamic> json) => GroupStanding(
        teamId: json['teamId'] as String,
        played: json['played'] as int,
        won: json['won'] as int,
        drawn: json['drawn'] as int,
        lost: json['lost'] as int,
        goalsFor: json['goalsFor'] as int,
        goalsAgainst: json['goalsAgainst'] as int,
      );
}

class GroupEntity {
  final String letter;
  final List<String> teamIds;
  final List<GroupStanding> standings;

  const GroupEntity({
    required this.letter,
    required this.teamIds,
    this.standings = const [],
  });

  GroupEntity copyWith({
    List<GroupStanding>? standings,
  }) =>
      GroupEntity(
        letter: letter,
        teamIds: teamIds,
        standings: standings ?? this.standings,
      );

  Map<String, dynamic> toJson() => {
        'letter': letter,
        'teamIds': teamIds,
        'standings': standings.map((s) => s.toJson()).toList(),
      };

  factory GroupEntity.fromJson(Map<String, dynamic> json) => GroupEntity(
        letter: json['letter'] as String,
        teamIds: List<String>.from(json['teamIds'] as List),
        standings: (json['standings'] as List? ?? [])
            .map((s) => GroupStanding.fromJson(s as Map<String, dynamic>))
            .toList(),
      );
}
