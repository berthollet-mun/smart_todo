import '../models/stats_model.dart';
import 'api_response.dart';

/// Réponse pour les STATISTIQUES
class StatsResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final StatsModel? stats;

  StatsResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.stats,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "lists": { ... },
  ///     "items": { ... },
  ///     "sharing": { ... },
  ///     "timeline": { ... },
  ///     "summary": { ... }
  ///   }
  /// }
  factory StatsResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return StatsResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      StatsModel? stats;
      if (data != null) {
        stats = StatsModel.fromJson(data);
      }

      return StatsResponse._(
        isSuccess: true,
        message: apiResponse.message,
        stats: stats,
      );
    } catch (e) {
      return StatsResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing des stats: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  // ─── RACCOURCIS ───────────────────────────────────────
  bool get hasStats => stats != null;

  // Listes
  int get totalLists => stats?.lists.total ?? 0;
  int get activeLists => stats?.lists.active ?? 0;
  int get completedLists => stats?.lists.completed ?? 0;

  // Items
  int get totalItems => stats?.items.total ?? 0;
  int get completedItems => stats?.items.completed ?? 0;
  double get completionRate => stats?.items.completionRate ?? 0.0;

  // Partage
  int get listsSharedByMe => stats?.sharing.listsSharedByMe ?? 0;
  int get listsSharedWithMe => stats?.sharing.listsSharedWithMe ?? 0;

  // Summary
  int get totalShares => stats?.summary.totalShares ?? 0;

  @override
  String toString() {
    return 'StatsResponse(isSuccess: $isSuccess, '
        'totalLists: $totalLists, completionRate: $completionRate%)';
  }
}