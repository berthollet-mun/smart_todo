import '../models/item_model.dart';
import 'api_response.dart';

/// Réponse pour un item (create, update)
class ItemResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final ItemModel? item;

  ItemResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.item,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "item": { ... }
  ///   }
  /// }
  factory ItemResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return ItemResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      ItemModel? item;
      if (data != null && data['item'] is Map<String, dynamic>) {
        item = ItemModel.fromJson(data['item']);
      }

      return ItemResponse._(
        isSuccess: true,
        message: apiResponse.message,
        item: item,
      );
    } catch (e) {
      return ItemResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get hasItem => item != null;

  @override
  String toString() {
    return 'ItemResponse(isSuccess: $isSuccess, '
        'item: ${item?.title})';
  }
}

/// Réponse pour le TOGGLE d'un item (item + list_status)
class ToggleItemResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final ItemModel? item;
  final String? listStatus; // 'active' ou 'completed'

  ToggleItemResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.item,
    this.listStatus,
  });

  /// Parse depuis ApiResponse
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "item": { ... },
  ///     "list_status": "active"
  ///   }
  /// }
  factory ToggleItemResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return ToggleItemResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      ItemModel? item;
      String? listStatus;

      if (data != null) {
        if (data['item'] is Map<String, dynamic>) {
          item = ItemModel.fromJson(data['item']);
        }
        listStatus = data['list_status']?.toString();
      }

      return ToggleItemResponse._(
        isSuccess: true,
        message: apiResponse.message,
        item: item,
        listStatus: listStatus,
      );
    } catch (e) {
      return ToggleItemResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get hasItem => item != null;
  bool get isListCompleted => listStatus == 'completed';
  bool get isListActive => listStatus == 'active';

  @override
  String toString() {
    return 'ToggleItemResponse(isSuccess: $isSuccess, '
        'item: ${item?.title}, isDone: ${item?.isDone}, '
        'listStatus: $listStatus)';
  }
}

/// Réponse pour la suppression d'un item
class DeleteItemResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;

  DeleteItemResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
  });

  factory DeleteItemResponse.fromApiResponse(ApiResponse apiResponse) {
    return DeleteItemResponse._(
      isSuccess: apiResponse.isSuccess,
      message: apiResponse.message,
      errorCode: apiResponse.errorCode,
    );
  }

  @override
  String toString() {
    return 'DeleteItemResponse(isSuccess: $isSuccess, '
        'message: $message)';
  }
}