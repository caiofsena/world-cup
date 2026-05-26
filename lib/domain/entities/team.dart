class Team {
  final String id;
  final String name;
  final String fifaCode;
  final String flagCode;

  const Team({
    required this.id,
    required this.name,
    required this.fifaCode,
    required this.flagCode,
  });

  String get flagUrl =>
      'https://flagcdn.com/w80/${flagCode.toLowerCase()}.png';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'fifaCode': fifaCode,
        'flagCode': flagCode,
      };

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json['id'] as String,
        name: json['name'] as String,
        fifaCode: json['fifaCode'] as String,
        flagCode: json['flagCode'] as String,
      );
}
