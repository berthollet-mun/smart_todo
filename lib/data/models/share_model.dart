class ShareModel {
  final int id;
  final int sharedWithUserId;
  final String permission; // 'read' ou 'edit'
  final String sharedWithName;
  final String sharedWithEmail;

  ShareModel({
    required this.id,
    required this.sharedWithUserId,
    required this.permission,
    required this.sharedWithName,
    required this.sharedWithEmail,
  });

  factory ShareModel.fromJson(Map<String, dynamic> json) {
    return ShareModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      sharedWithUserId: json['shared_with_user_id'] is int
          ? json['shared_with_user_id']
          : int.parse(json['shared_with_user_id'].toString()),
      permission: json['permission'] ?? 'read',
      sharedWithName: json['shared_with_name'] ?? '',
      sharedWithEmail: json['shared_with_email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shared_with_user_id': sharedWithUserId,
      'permission': permission,
      'shared_with_name': sharedWithName,
      'shared_with_email': sharedWithEmail,
    };
  }

  bool get canEdit => permission == 'edit';
  bool get isReadOnly => permission == 'read';

  ShareModel copyWith({
    int? id,
    int? sharedWithUserId,
    String? permission,
    String? sharedWithName,
    String? sharedWithEmail,
  }) {
    return ShareModel(
      id: id ?? this.id,
      sharedWithUserId: sharedWithUserId ?? this.sharedWithUserId,
      permission: permission ?? this.permission,
      sharedWithName: sharedWithName ?? this.sharedWithName,
      sharedWithEmail: sharedWithEmail ?? this.sharedWithEmail,
    );
  }

  @override
  String toString() =>
      'ShareModel(id: $id, user: $sharedWithName, permission: $permission)';
}