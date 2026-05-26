class MatchEntity {
  final int id;
  final String phase;
  final String? group;
  final String homeTeamId;
  final String awayTeamId;
  final DateTime date;
  final String stadium;
  final String city;
  final int? homeGoals;
  final int? awayGoals;

  const MatchEntity({
    required this.id,
    required this.phase,
    this.group,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.date,
    required this.stadium,
    required this.city,
    this.homeGoals,
    this.awayGoals,
  });

  bool get isPlayed => homeGoals != null && awayGoals != null;

  String get result =>
      isPlayed ? '$homeGoals - $awayGoals' : 'vs';

  Map<String, dynamic> toJson() => {
        'id': id,
        'phase': phase,
        'group': group,
        'homeTeamId': homeTeamId,
        'awayTeamId': awayTeamId,
        'date': date.toIso8601String(),
        'stadium': stadium,
        'city': city,
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
      };

  factory MatchEntity.fromJson(Map<String, dynamic> json) => MatchEntity(
        id: json['id'] as int,
        phase: json['phase'] as String,
        group: json['group'] as String?,
        homeTeamId: json['homeTeamId'] as String,
        awayTeamId: json['awayTeamId'] as String,
        date: DateTime.parse(json['date'] as String),
        stadium: json['stadium'] as String,
        city: json['city'] as String,
        homeGoals: json['homeGoals'] as int?,
        awayGoals: json['awayGoals'] as int?,
      );
}
