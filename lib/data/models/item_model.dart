class ItemModel {
  final int id;
  final int listId;
  final String title;
  final bool isDone;
  final String? createdAt;

  ItemModel({
    required this.id,
    required this.listId,
    required this.title,
    this.isDone = false,
    this.createdAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      listId: json['list_id'] is int
          ? json['list_id']
          : int.tryParse(json['list_id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? '',
      isDone: json['is_done'] == 1 ||
          json['is_done'] == true ||
          json['is_done'] == '1',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list_id': listId,
      'title': title,
      'is_done': isDone ? 1 : 0,
      'created_at': createdAt,
    };
  }

  /// Pour créer un item (body de la requête POST)
  Map<String, dynamic> toCreateJson() {
    return {
      'list_id': listId,
      'title': title,
    };
  }

  /// Pour mettre à jour un item (body de la requête PUT)
  Map<String, dynamic> toUpdateJson() {
    return {
      'title': title,
    };
  }

  ItemModel copyWith({
    int? id,
    int? listId,
    String? title,
    bool? isDone,
    String? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() =>
      'ItemModel(id: $id, listId: $listId, title: $title, isDone: $isDone)';
}