import 'item_model.dart';
import 'share_model.dart';

class TaskListModel {
  final int id;
  final int? userId;
  final String title;
  final String type; // 'simple' ou 'checklist'
  final String? description;
  final String status; // 'active' ou 'completed'
  final String? dueDate;
  final String? dueTime;
  final String? createdAt;
  final String? ownerName;
  final int totalItems;
  final int completedItems;
  final String? source; // 'personal' ou 'shared' (calendrier)
  final String? permission; // pour les listes partagées avec moi
  final String? ownerEmail; // pour les listes partagées avec moi
  final List<ItemModel> items;
  final List<ShareModel> sharedWith;

  TaskListModel({
    required this.id,
    this.userId,
    required this.title,
    required this.type,
    this.description,
    this.status = 'active',
    this.dueDate,
    this.dueTime,
    this.createdAt,
    this.ownerName,
    this.totalItems = 0,
    this.completedItems = 0,
    this.source,
    this.permission,
    this.ownerEmail,
    this.items = const [],
    this.sharedWith = const [],
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) {
    return TaskListModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      userId: json['user_id'] != null
          ? (json['user_id'] is int
              ? json['user_id']
              : int.parse(json['user_id'].toString()))
          : null,
      title: json['title'] ?? '',
      type: json['type'] ?? 'simple',
      description: json['description'],
      status: json['status'] ?? 'active',
      dueDate: json['due_date'],
      dueTime: json['due_time'],
      createdAt: json['created_at'],
      ownerName: json['owner_name'],
      totalItems: json['total_items'] is int
          ? json['total_items']
          : int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      completedItems: json['completed_items'] is int
          ? json['completed_items']
          : int.tryParse(json['completed_items']?.toString() ?? '0') ?? 0,
      source: json['source'],
      permission: json['permission'],
      ownerEmail: json['owner_email'],
      items: [],
      sharedWith: [],
    );
  }

  /// Parsing complet avec items et shared_with (détail d'une liste)
  factory TaskListModel.fromDetailJson({
    required Map<String, dynamic> listJson,
    List<dynamic>? itemsJson,
    List<dynamic>? sharedWithJson,
  }) {
    return TaskListModel(
      id: listJson['id'] is int
          ? listJson['id']
          : int.parse(listJson['id'].toString()),
      userId: listJson['user_id'] != null
          ? (listJson['user_id'] is int
              ? listJson['user_id']
              : int.parse(listJson['user_id'].toString()))
          : null,
      title: listJson['title'] ?? '',
      type: listJson['type'] ?? 'simple',
      description: listJson['description'],
      status: listJson['status'] ?? 'active',
      dueDate: listJson['due_date'],
      dueTime: listJson['due_time'],
      createdAt: listJson['created_at'],
      ownerName: listJson['owner_name'],
      totalItems: listJson['total_items'] is int
          ? listJson['total_items']
          : int.tryParse(listJson['total_items']?.toString() ?? '0') ?? 0,
      completedItems: listJson['completed_items'] is int
          ? listJson['completed_items']
          : int.tryParse(listJson['completed_items']?.toString() ?? '0') ?? 0,
      items: itemsJson != null
          ? itemsJson
              .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      sharedWith: sharedWithJson != null
          ? sharedWithJson
              .map((e) => ShareModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'type': type,
      'description': description,
      'status': status,
      'due_date': dueDate,
      'due_time': dueTime,
      'created_at': createdAt,
    };
  }

  /// Pour créer une liste (body de la requête POST)
  Map<String, dynamic> toCreateJson() {
    final map = <String, dynamic>{
      'title': title,
      'type': type,
    };
    if (description != null && description!.isNotEmpty) {
      map['description'] = description;
    }
    if (dueDate != null && dueDate!.isNotEmpty) {
      map['due_date'] = dueDate;
    }
    if (dueTime != null && dueTime!.isNotEmpty) {
      map['due_time'] = dueTime;
    }
    return map;
  }

  /// Pour mettre à jour une liste (body de la requête PUT)
  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    if (description != null) map['description'] = description;
    map['status'] = status;
    if (dueDate != null) map['due_date'] = dueDate;
    if (dueTime != null) map['due_time'] = dueTime;
    return map;
  }

  bool get isChecklist => type == 'checklist';
  bool get isSimple => type == 'simple';
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  int get pendingItems => totalItems - completedItems;

  double get completionPercentage {
    if (totalItems == 0) return 0.0;
    return (completedItems / totalItems) * 100;
  }

  TaskListModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? type,
    String? description,
    String? status,
    String? dueDate,
    String? dueTime,
    String? createdAt,
    String? ownerName,
    int? totalItems,
    int? completedItems,
    String? source,
    String? permission,
    String? ownerEmail,
    List<ItemModel>? items,
    List<ShareModel>? sharedWith,
  }) {
    return TaskListModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      type: type ?? this.type,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      createdAt: createdAt ?? this.createdAt,
      ownerName: ownerName ?? this.ownerName,
      totalItems: totalItems ?? this.totalItems,
      completedItems: completedItems ?? this.completedItems,
      source: source ?? this.source,
      permission: permission ?? this.permission,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      items: items ?? this.items,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }

  @override
  String toString() =>
      'TaskListModel(id: $id, title: $title, type: $type, status: $status)';
}