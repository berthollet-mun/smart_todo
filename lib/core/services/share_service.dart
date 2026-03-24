import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/models/task_list_model.dart';
import '../../data/responses/api_response.dart';
import 'api_service.dart';

class ShareService extends GetxService {
  final ApiService _api = Get.find();

  // ─── RECHERCHER DES UTILISATEURS ─────────────────────
  Future<ApiResponse> searchUsers(String query) async {
    return await _api.get('/users/search?query=$query');
  }

  // ─── PARTAGER UNE LISTE ──────────────────────────────
  Future<ApiResponse> shareList({
    required int listId,
    required int userId,
    required String permission, // 'read' ou 'edit'
  }) async {
    return await _api.post('/lists/$listId/share', {
      'user_id': userId,
      'permission': permission,
    });
  }

  // ─── RÉCUPÉRER LES LISTES PARTAGÉES AVEC MOI ─────────
  Future<ApiResponse> getSharedLists() async {
    return await _api.get('/lists/shared');
  }

  // ─── RETIRER UN PARTAGE ──────────────────────────────
  Future<ApiResponse> removeShare({
    required int listId,
    required int userId,
  }) async {
    return await _api.delete('/lists/$listId/share/$userId');
  }

  // ─── HELPERS ──────────────────────────────────────────
  /// Parse les utilisateurs trouvés lors d'une recherche
  List<UserModel> parseSearchUsers(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return [];
    final usersData = response.data!['data']?['users'];
    if (usersData is! List) return [];
    return usersData
        .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Parse les listes partagées avec moi
  List<TaskListModel> parseSharedLists(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return [];
    final listsData = response.data!['data']?['shared_lists'];
    if (listsData is! List) return [];
    return listsData
        .map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}