import '../models/task_list_model.dart';
import '../models/item_model.dart';
import '../models/share_model.dart';
import 'api_response.dart';

/// Réponse pour le DÉTAIL d'une liste (list + items + shared_with)
class ListDetailResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final TaskListModel? list;
  final List<ItemModel> items;
  final List<ShareModel> sharedWith;

  ListDetailResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.list,
    this.items = const [],
    this.sharedWith = const [],
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "list": { ... },
  ///     "items": [ ... ],
  ///     "shared_with": [ ... ]
  ///   }
  /// }
  factory ListDetailResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return ListDetailResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      if (data == null) {
        return ListDetailResponse._(
          isSuccess: false,
          message: 'Données manquantes',
          errorCode: 'NO_DATA',
        );
      }

      // Parser les items
      List<ItemModel> items = [];
      if (data['items'] is List) {
        items = (data['items'] as List)
            .map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Parser les partages
      List<ShareModel> sharedWith = [];
      if (data['shared_with'] is List) {
        sharedWith = (data['shared_with'] as List)
            .map((e) => ShareModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      // Parser la liste avec ses items et partages
      TaskListModel? list;
      if (data['list'] is Map<String, dynamic>) {
        list = TaskListModel.fromDetailJson(
          listJson: data['list'],
          itemsJson: data['items'] as List<dynamic>?,
          sharedWithJson: data['shared_with'] as List<dynamic>?,
        );
      }

      return ListDetailResponse._(
        isSuccess: true,
        message: apiResponse.message,
        list: list,
        items: items,
        sharedWith: sharedWith,
      );
    } catch (e) {
      return ListDetailResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing du détail: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get hasList => list != null;
  bool get hasItems => items.isNotEmpty;
  bool get hasShares => sharedWith.isNotEmpty;
  bool get isChecklist => list?.isChecklist ?? false;
  int get totalItems => items.length;
  int get completedItems => items.where((i) => i.isDone).length;
  int get pendingItems => items.where((i) => !i.isDone).length;

  @override
  String toString() {
    return 'ListDetailResponse(isSuccess: $isSuccess, '
        'list: ${list?.title}, items: ${items.length}, '
        'shares: ${sharedWith.length})';
  }
}