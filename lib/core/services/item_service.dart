import 'package:get/get.dart';

import '../../data/models/item_model.dart';
import '../../data/responses/api_response.dart';
import 'api_service.dart';

class ItemService extends GetxService {
  final ApiService _api = Get.find();

  // ─── AJOUTER UN ITEM ─────────────────────────────────
  Future<ApiResponse> createItem({
    required int listId,
    required String title,
  }) async {
    return await _api.post('/items', {
      'list_id': listId,
      'title': title,
    });
  }

  // ─── MODIFIER LE TITRE D'UN ITEM ─────────────────────
  Future<ApiResponse> updateItem({
    required int itemId,
    required String title,
  }) async {
    return await _api.put('/items/$itemId', {
      'title': title,
    });
  }

  // ─── TOGGLE COCHÉ/DÉCOCHÉ ────────────────────────────
  Future<ApiResponse> toggleItem(int itemId) async {
    return await _api.patch('/items/$itemId/toggle');
  }

  // ─── SUPPRIMER UN ITEM ────────────────────────────────
  Future<ApiResponse> deleteItem(int itemId) async {
    return await _api.delete('/items/$itemId');
  }

  // ─── HELPERS : PARSER UN ITEM ─────────────────────────
  ItemModel? parseItem(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final itemData = response.data!['data']?['item'];
    if (itemData == null) return null;
    return ItemModel.fromJson(itemData);
  }

  /// Récupère le list_status retourné lors du toggle
  String? parseListStatus(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    return response.data!['data']?['list_status']?.toString();
  }
}