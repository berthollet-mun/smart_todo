class StatsModel {
  final ListStats lists;
  final ItemStats items;
  final SharingStats sharing;
  final TimelineStats timeline;
  final SummaryStats summary;

  StatsModel({
    required this.lists,
    required this.items,
    required this.sharing,
    required this.timeline,
    required this.summary,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      lists: ListStats.fromJson(
        json['lists'] is Map<String, dynamic>
            ? json['lists']
            : <String, dynamic>{},
      ),
      items: ItemStats.fromJson(
        json['items'] is Map<String, dynamic>
            ? json['items']
            : <String, dynamic>{},
      ),
      sharing: SharingStats.fromJson(
        json['sharing'] is Map<String, dynamic>
            ? json['sharing']
            : <String, dynamic>{},
      ),
      timeline: TimelineStats.fromJson(
        json['timeline'] is Map<String, dynamic>
            ? json['timeline']
            : <String, dynamic>{},
      ),
      summary: SummaryStats.fromJson(
        json['summary'] is Map<String, dynamic>
            ? json['summary']
            : <String, dynamic>{},
      ),
    );
  }
}

// ─── LIST STATS ───────────────────────────────────────
class ListStats {
  final int total;
  final int active;
  final int completed;
  final int simple;
  final int checklist;

  ListStats({
    required this.total,
    required this.active,
    required this.completed,
    required this.simple,
    required this.checklist,
  });

  factory ListStats.fromJson(Map<String, dynamic> json) {
    return ListStats(
      total: _p(json['total']),
      active: _p(json['active']),
      completed: _p(json['completed']),
      simple: _p(json['simple']),
      checklist: _p(json['checklist']),
    );
  }
}

// ─── ITEM STATS ───────────────────────────────────────
class ItemStats {
  final int total;
  final int completed;
  final int pending;
  final double completionRate;

  ItemStats({
    required this.total,
    required this.completed,
    required this.pending,
    required this.completionRate,
  });

  factory ItemStats.fromJson(Map<String, dynamic> json) {
    return ItemStats(
      total: _p(json['total']),
      completed: _p(json['completed']),
      pending: _p(json['pending']),
      completionRate: _pDouble(json['completion_rate']),
    );
  }
}

// ─── SHARING STATS ────────────────────────────────────
class SharingStats {
  final int listsSharedByMe;
  final int totalSharesSent;
  final int editPermissionsGranted;
  final int readPermissionsGranted;
  final int listsSharedWithMe;
  final int listsICanEdit;

  SharingStats({
    required this.listsSharedByMe,
    required this.totalSharesSent,
    required this.editPermissionsGranted,
    required this.readPermissionsGranted,
    required this.listsSharedWithMe,
    required this.listsICanEdit,
  });

  factory SharingStats.fromJson(Map<String, dynamic> json) {
    return SharingStats(
      listsSharedByMe: _p(json['lists_shared_by_me']),
      totalSharesSent: _p(json['total_shares_sent']),
      editPermissionsGranted: _p(json['edit_permissions_granted']),
      readPermissionsGranted: _p(json['read_permissions_granted']),
      listsSharedWithMe: _p(json['lists_shared_with_me']),
      listsICanEdit: _p(json['lists_i_can_edit']),
    );
  }
}

// ─── TIMELINE STATS ───────────────────────────────────
class TimelineStats {
  final List<DailyStats> daily;
  final List<MonthlyStats> monthly;

  TimelineStats({
    required this.daily,
    required this.monthly,
  });

  factory TimelineStats.fromJson(Map<String, dynamic> json) {
    return TimelineStats(
      daily: json['daily'] is List
          ? (json['daily'] as List)
              .map((e) => DailyStats.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      monthly: json['monthly'] is List
          ? (json['monthly'] as List)
              .map((e) => MonthlyStats.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class DailyStats {
  final String date;
  final int listsCount;
  final int completedCount;

  DailyStats({
    required this.date,
    required this.listsCount,
    required this.completedCount,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: json['date'] ?? '',
      listsCount: _p(json['lists_count']),
      completedCount: _p(json['completed_count']),
    );
  }
}

class MonthlyStats {
  final String month;
  final int listsCount;
  final int completedCount;

  MonthlyStats({
    required this.month,
    required this.listsCount,
    required this.completedCount,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      month: json['month'] ?? '',
      listsCount: _p(json['lists_count']),
      completedCount: _p(json['completed_count']),
    );
  }
}

// ─── SUMMARY STATS ────────────────────────────────────
class SummaryStats {
  final int totalLists;
  final int totalItems;
  final int totalCompletedItems;
  final double completionRate;
  final int totalShares;

  SummaryStats({
    required this.totalLists,
    required this.totalItems,
    required this.totalCompletedItems,
    required this.completionRate,
    required this.totalShares,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      totalLists: _p(json['total_lists']),
      totalItems: _p(json['total_items']),
      totalCompletedItems: _p(json['total_completed_items']),
      completionRate: _pDouble(json['completion_rate']),
      totalShares: _p(json['total_shares']),
    );
  }
}

// ─── HELPERS PRIVÉS ───────────────────────────────────
int _p(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '0') ?? 0;
}

double _pDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value?.toString() ?? '0.0') ?? 0.0;
}