import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/prediction_local_datasource.dart';
import '../../data/repositories/prediction_repository_impl.dart';
import '../../domain/entities/prediction.dart';
import 'auth_providers.dart';

final predictionDatasourceProvider = Provider(
  (ref) => PredictionLocalDatasource(),
);

final predictionRepositoryProvider = Provider(
  (ref) => PredictionRepositoryImpl(
    ref.watch(predictionDatasourceProvider),
  ),
);

final predictionInitProvider = FutureProvider<void>((ref) async {
  final repo = ref.watch(predictionRepositoryProvider);
  await repo.init();
});

final userPredictionsProvider = FutureProvider<List<Prediction>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  final repo = ref.watch(predictionRepositoryProvider);
  return repo.getPredictionsByUser(user.uid);
});

final predictionByMatchProvider =
    FutureProvider.family<Prediction?, int>((ref, matchId) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  final repo = ref.watch(predictionRepositoryProvider);
  return repo.getPrediction(user.uid, matchId);
});

class SavePredictionState {
  final bool isLoading;
  final String? error;

  const SavePredictionState({this.isLoading = false, this.error});
}

class SavePredictionNotifier extends StateNotifier<SavePredictionState> {
  final PredictionRepositoryImpl _repo;

  SavePredictionNotifier(this._repo) : super(const SavePredictionState());

  Future<bool> save(String userId, int matchId, int homeGoals, int awayGoals) async {
    state = const SavePredictionState(isLoading: true);
    try {
      await _repo.savePrediction(Prediction(
        userId: userId,
        matchId: matchId,
        homeGoals: homeGoals,
        awayGoals: awayGoals,
        updatedAt: DateTime.now(),
      ));
      state = const SavePredictionState();
      return true;
    } catch (e) {
      state = SavePredictionState(error: e.toString());
      return false;
    }
  }
}

final savePredictionProvider =
    StateNotifierProvider<SavePredictionNotifier, SavePredictionState>(
  (ref) => SavePredictionNotifier(
    ref.watch(predictionRepositoryProvider),
  ),
);

final predictionPointsProvider =
    FutureProvider.family<int, Map<int, Map<String, int?>>>(
  (ref, actualResults) async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return 0;
    final repo = ref.watch(predictionRepositoryProvider);
    return repo.calculatePoints(user.uid, actualResults);
  },
);
