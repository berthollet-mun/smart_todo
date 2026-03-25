

import 'package:smart_todo/data/models/task_list_model.dart';

class CalendarModel {
  final String date;
  final CalendarStats stats;
  final List<TaskListModel> lists;
  final Map<String, List<TaskListModel>> groupedByHour;

  CalendarModel({
    required this.date,
    required this.stats,
    required this.lists,
    required this.groupedByHour,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) {
    // Parse les listes
    final List<TaskListModel> parsedLists = [];
    if (json['lists'] is List) {
      for (var item in json['lists'] as List) {
        parsedLists.add(TaskListModel.fromJson(item as Map<String, dynamic>));
      }
    }

    // Parse grouped_by_hour
    final Map<String, List<TaskListModel>> grouped = {};
    if (json['grouped_by_hour'] is Map) {
      final groupedJson = json['grouped_by_hour'] as Map<String, dynamic>;
      for (var key in groupedJson.keys) {
        if (groupedJson[key] is List) {
          grouped[key] = (groupedJson[key] as List)
              .map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    }

    return CalendarModel(
      date: json['date'] ?? '',
      stats: CalendarStats.fromJson(
        json['stats'] is Map<String, dynamic>
            ? json['stats']
            : <String, dynamic>{},
      ),
      lists: parsedLists,
      groupedByHour: grouped,
    );
  }

  @override
  String toString() =>
      'CalendarModel(date: $date, totalLists: ${stats.totalLists})';
}

class CalendarStats {
  final int totalLists;
  final int personalLists;
  final int sharedLists;
  final int completedLists;
  final int activeLists;

  CalendarStats({
    required this.totalLists,
    required this.personalLists,
    required this.sharedLists,
    required this.completedLists,
    required this.activeLists,
  });

  factory CalendarStats.fromJson(Map<String, dynamic> json) {
    return CalendarStats(
      totalLists: _parseInt(json['total_lists']),
      personalLists: _parseInt(json['personal_lists']),
      sharedLists: _parseInt(json['shared_lists']),
      completedLists: _parseInt(json['completed_lists']),
      activeLists: _parseInt(json['active_lists']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'total_lists': totalLists,
      'personal_lists': personalLists,
      'shared_lists': sharedLists,
      'completed_lists': completedLists,
      'active_lists': activeLists,
    };
  }
}