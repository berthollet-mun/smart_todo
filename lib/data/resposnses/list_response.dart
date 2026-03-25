import '../models/task_list_model.dart';
import '../models/pagination_model.dart';
import 'api_response.dart';

/// Réponse pour une SEULE liste (create, update, duplicate)
class SingleListResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final TaskListModel? list;

  SingleListResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.list,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "message": "Liste créée avec succès",
  ///   "data": {
  ///     "list": { ... }
  ///   }
  /// }
  factory SingleListResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return SingleListResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      TaskListModel? list;
      if (data != null && data['list'] is Map<String, dynamic>) {
        list = TaskListModel.fromJson(data['list']);
      }

      return SingleListResponse._(
        isSuccess: true,
        message: apiResponse.message,
        list: list,
      );
    } catch (e) {
      return SingleListResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get hasList => list != null;

  @override
  String toString() {
    return 'SingleListResponse(isSuccess: $isSuccess, '
        'list: ${list?.title})';
  }
}

/// Réponse pour PLUSIEURS listes avec pagination (getAll)
class MultipleListResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final List<TaskListModel> lists;
  final PaginationModel? pagination;

  MultipleListResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.lists = const [],
    this.pagination,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "lists": [ ... ],
  ///     "pagination": { ... }
  ///   }
  /// }
  factory MultipleListResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return MultipleListResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      List<TaskListModel> lists = [];
      PaginationModel? pagination;

      if (data != null) {
        // Parser les listes
        if (data['lists'] is List) {
          lists = (data['lists'] as List)
              .map((e) =>
                  TaskListModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        // Parser la pagination
        if (data['pagination'] is Map<String, dynamic>) {
          pagination = PaginationModel.fromJson(data['pagination']);
        }
      }

      return MultipleListResponse._(
        isSuccess: true,
        message: apiResponse.message,
        lists: lists,
        pagination: pagination,
      );
    } catch (e) {
      return MultipleListResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get isEmpty => lists.isEmpty;
  bool get isNotEmpty => lists.isNotEmpty;
  int get count => lists.length;
  bool get hasNextPage => pagination?.hasNext ?? false;
  bool get hasPrevPage => pagination?.hasPrev ?? false;

  @override
  String toString() {
    return 'MultipleListResponse(isSuccess: $isSuccess, '
        'count: $count, page: ${pagination?.currentPage})';
  }
}

/// Réponse pour la suppression d'une liste (pas de data)
class DeleteListResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;

  DeleteListResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
  });

  factory DeleteListResponse.fromApiResponse(ApiResponse apiResponse) {
    return DeleteListResponse._(
      isSuccess: apiResponse.isSuccess,
      message: apiResponse.message,
      errorCode: apiResponse.errorCode,
    );
  }

  @override
  String toString() {
    return 'DeleteListResponse(isSuccess: $isSuccess, '
        'message: $message)';
  }
}