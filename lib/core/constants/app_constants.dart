class AppConstants {
  static const appName = 'Copa 2026';
  static const tournamentStart = '2026-06-11';
  static const tournamentEnd = '2026-07-19';

  static const phases = [
    'group',
    'round32',
    'round16',
    'quarter',
    'semi',
    'thirdPlace',
    'final',
  ];

  static const phaseLabels = {
    'group': 'Fase de Grupos',
    'round32': '16-avos de Final',
    'round16': 'Oitavas de Final',
    'quarter': 'Quartas de Final',
    'semi': 'Semifinais',
    'thirdPlace': '3º Lugar',
    'final': 'Final',
  };

  static const groupLetters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L',
  ];

  static const pointsPerWin = 3;
  static const pointsPerDraw = 1;
  static const pointsPerLoss = 0;

  static const predictionPointsExact = 10;
  static const predictionPointsGoalDiff = 5;
  static const predictionPointsResult = 3;
}
