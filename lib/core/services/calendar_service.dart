import 'package:get/get.dart';

import '../../data/models/calendar_model.dart';
import '../../data/responses/api_response.dart';
import 'api_service.dart';

class CalendarService extends GetxService {
  final ApiService _api = Get.find();

  // ─── RÉCUPÉRER LE CALENDRIER POUR UNE DATE ───────────
  /// [date] format YYYY-MM-DD. Si null, l'API retourne aujourd'hui.
  Future<ApiResponse> getCalendar({String? date}) async {
    final endpoint =
        date != null ? '/calendar?date=$date' : '/calendar';
    return await _api.get(endpoint);
  }

  // ─── HELPER : PARSER LE CALENDRIER ────────────────────
  CalendarModel? parseCalendar(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final data = response.data!['data'];
    if (data == null) return null;
    return CalendarModel.fromJson(data);
  }
}