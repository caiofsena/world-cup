import '../../domain/entities/prediction.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../datasources/prediction_local_datasource.dart';
import '../../core/constants/app_constants.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionLocalDatasource _datasource;

  PredictionRepositoryImpl(this._datasource);

  @override
  Future<void> init() async {
    await _datasource.database;
  }

  @override
  Future<List<Prediction>> getPredictionsByUser(String userId) =>
      _datasource.getPredictionsByUser(userId);

  @override
  Future<Prediction?> getPrediction(String userId, int matchId) =>
      _datasource.getPrediction(userId, matchId);

  @override
  Future<void> savePrediction(Prediction prediction) =>
      _datasource.savePrediction(prediction);

  @override
  Future<void> deletePrediction(String userId, int matchId) =>
      _datasource.deletePrediction(userId, matchId);

  @override
  Future<int> calculatePoints(
      String userId, Map<int, Map<String, int?>> actualResults) async {
    final predictions = await _datasource.getPredictionsByUser(userId);
    var totalPoints = 0;

    for (final prediction in predictions) {
      final result = actualResults[prediction.matchId];
      if (result == null || result['home'] == null || result['away'] == null) {
        continue;
      }

      final actualHome = result['home']!;
      final actualAway = result['away']!;

      if (prediction.homeGoals == actualHome &&
          prediction.awayGoals == actualAway) {
        totalPoints += AppConstants.predictionPointsExact;
      } else if ((prediction.homeGoals - prediction.awayGoals) ==
          (actualHome - actualAway)) {
        totalPoints += AppConstants.predictionPointsGoalDiff;
      } else if ((prediction.homeGoals > prediction.awayGoals &&
              actualHome > actualAway) ||
          (prediction.homeGoals < prediction.awayGoals &&
              actualHome < actualAway) ||
          (prediction.homeGoals == prediction.awayGoals &&
              actualHome == actualAway)) {
        totalPoints += AppConstants.predictionPointsResult;
      }
    }

    return totalPoints;
  }
}
