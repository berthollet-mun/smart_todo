import '../models/user_model.dart';
import '../models/task_list_model.dart';
import 'api_response.dart';

/// Réponse pour la RECHERCHE d'utilisateurs
class UserSearchResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final List<UserModel> users;

  UserSearchResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.users = const [],
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "users": [ ... ]
  ///   }
  /// }
  factory UserSearchResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return UserSearchResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      List<UserModel> users = [];
      if (data != null && data['users'] is List) {
        users = (data['users'] as List)
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return UserSearchResponse._(
        isSuccess: true,
        message: apiResponse.message,
        users: users,
      );
    } catch (e) {
      return UserSearchResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get isEmpty => users.isEmpty;
  bool get isNotEmpty => users.isNotEmpty;
  int get count => users.length;

  @override
  String toString() {
    return 'UserSearchResponse(isSuccess: $isSuccess, '
        'count: $count)';
  }
}

/// Réponse pour le PARTAGE d'une liste
class ShareListResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final int? listId;
  final String? listTitle;
  final UserModel? sharedWithUser;
  final String? permission;

  ShareListResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.listId,
    this.listTitle,
    this.sharedWithUser,
    this.permission,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "share": {
  ///       "list_id": 1,
  ///       "list_title": "Courses",
  ///       "shared_with": { "id": 2, "name": "...", "email": "..." },
  ///       "permission": "edit"
  ///     }
  ///   }
  /// }
  factory ShareListResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return ShareListResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;
      final share = data?['share'] as Map<String, dynamic>?;

      int? listId;
      String? listTitle;
      UserModel? sharedWithUser;
      String? permission;

      if (share != null) {
        listId = share['list_id'] is int
            ? share['list_id']
            : int.tryParse(share['list_id']?.toString() ?? '');
        listTitle = share['list_title']?.toString();
        permission = share['permission']?.toString();

        if (share['shared_with'] is Map<String, dynamic>) {
          sharedWithUser = UserModel.fromJson(share['shared_with']);
        }
      }

      return ShareListResponse._(
        isSuccess: true,
        message: apiResponse.message,
        listId: listId,
        listTitle: listTitle,
        sharedWithUser: sharedWithUser,
        permission: permission,
      );
    } catch (e) {
      return ShareListResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get canEdit => permission == 'edit';

  @override
  String toString() {
    return 'ShareListResponse(isSuccess: $isSuccess, '
        'list: $listTitle, user: ${sharedWithUser?.name}, '
        'permission: $permission)';
  }
}

/// Réponse pour les listes PARTAGÉES AVEC MOI
class SharedListsResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final List<TaskListModel> sharedLists;

  SharedListsResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.sharedLists = const [],
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "shared_lists": [ ... ]
  ///   }
  /// }
  factory SharedListsResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return SharedListsResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      List<TaskListModel> sharedLists = [];
      if (data != null && data['shared_lists'] is List) {
        sharedLists = (data['shared_lists'] as List)
            .map((e) =>
                TaskListModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      return SharedListsResponse._(
        isSuccess: true,
        message: apiResponse.message,
        sharedLists: sharedLists,
      );
    } catch (e) {
      return SharedListsResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get isEmpty => sharedLists.isEmpty;
  bool get isNotEmpty => sharedLists.isNotEmpty;
  int get count => sharedLists.length;

  @override
  String toString() {
    return 'SharedListsResponse(isSuccess: $isSuccess, '
        'count: $count)';
  }
}

/// Réponse pour le RETRAIT d'un partage
class RemoveShareResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;

  RemoveShareResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
  });

  factory RemoveShareResponse.fromApiResponse(ApiResponse apiResponse) {
    return RemoveShareResponse._(
      isSuccess: apiResponse.isSuccess,
      message: apiResponse.message,
      errorCode: apiResponse.errorCode,
    );
  }

  @override
  String toString() {
    return 'RemoveShareResponse(isSuccess: $isSuccess, '
        'message: $message)';
  }
}