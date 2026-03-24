import 'package:get/get.dart';

import '../../data/models/stats_model.dart';
import '../../data/responses/api_response.dart';
import 'api_service.dart';

class StatsService extends GetxService {
  final ApiService _api = Get.find();

  // ─── RÉCUPÉRER LES STATISTIQUES ──────────────────────
  Future<ApiResponse> getStats() async {
    return await _api.get('/stats');
  }

  // ─── HELPER : PARSER LES STATS ───────────────────────
  StatsModel? parseStats(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final data = response.data!['data'];
    if (data == null) return null;
    return StatsModel.fromJson(data);
  }
}