import '../models/calendar_model.dart';
import '../models/task_list_model.dart';
import 'api_response.dart';

/// Réponse pour le CALENDRIER
class CalendarResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final CalendarModel? calendar;

  CalendarResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.calendar,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "date": "2024-12-25",
  ///     "stats": { ... },
  ///     "lists": [ ... ],
  ///     "grouped_by_hour": { ... }
  ///   }
  /// }
  factory CalendarResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return CalendarResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      CalendarModel? calendar;
      if (data != null) {
        calendar = CalendarModel.fromJson(data);
      }

      return CalendarResponse._(
        isSuccess: true,
        message: apiResponse.message,
        calendar: calendar,
      );
    } catch (e) {
      return CalendarResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing du calendrier: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  // ─── RACCOURCIS ───────────────────────────────────────
  bool get hasCalendar => calendar != null;
  String get date => calendar?.date ?? '';
  List<TaskListModel> get lists => calendar?.lists ?? [];
  int get totalLists => calendar?.stats.totalLists ?? 0;
  int get activeLists => calendar?.stats.activeLists ?? 0;
  int get completedLists => calendar?.stats.completedLists ?? 0;
  bool get isEmpty => lists.isEmpty;
  bool get isNotEmpty => lists.isNotEmpty;

  Map<String, List<TaskListModel>> get groupedByHour =>
      calendar?.groupedByHour ?? {};

  @override
  String toString() {
    return 'CalendarResponse(isSuccess: $isSuccess, '
        'date: $date, totalLists: $totalLists)';
  }
}