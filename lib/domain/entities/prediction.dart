class Prediction {
  final int? id;
  final String userId;
  final int matchId;
  final int homeGoals;
  final int awayGoals;
  final DateTime updatedAt;

  const Prediction({
    this.id,
    required this.userId,
    required this.matchId,
    required this.homeGoals,
    required this.awayGoals,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'matchId': matchId,
        'homeGoals': homeGoals,
        'awayGoals': awayGoals,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        id: json['id'] as int?,
        userId: json['userId'] as String,
        matchId: json['matchId'] as int,
        homeGoals: json['homeGoals'] as int,
        awayGoals: json['awayGoals'] as int,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
