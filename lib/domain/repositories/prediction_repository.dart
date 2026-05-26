import '../entities/prediction.dart';

abstract class PredictionRepository {
  Future<void> init();
  Future<List<Prediction>> getPredictionsByUser(String userId);
  Future<Prediction?> getPrediction(String userId, int matchId);
  Future<void> savePrediction(Prediction prediction);
  Future<void> deletePrediction(String userId, int matchId);
  Future<int> calculatePoints(String userId, Map<int, Map<String, int?>> actualResults);
}
