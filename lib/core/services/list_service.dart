import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/pagination_model.dart';
import '../../data/responses/api_response.dart';
import 'api_service.dart';

class ListService extends GetxService {
  final ApiService _api = Get.find();

  // ─── CRÉER UNE LISTE ─────────────────────────────────
  Future<ApiResponse> createList({
    required String title,
    required String type,
    String? description,
    String? dueDate,
    String? dueTime,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'type': type,
    };
    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }
    if (dueDate != null && dueDate.isNotEmpty) {
      body['due_date'] = dueDate;
    }
    if (dueTime != null && dueTime.isNotEmpty) {
      body['due_time'] = dueTime;
    }

    return await _api.post('/lists', body);
  }

  // ─── RÉCUPÉRER TOUTES LES LISTES (AVEC FILTRES) ──────
  Future<ApiResponse> getLists({
    String? status,
    String? type,
    String? search,
    String? date,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) params['status'] = status;
    if (type != null) params['type'] = type;
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (date != null) params['date'] = date;

    final queryString = Uri(queryParameters: params).query;
    return await _api.get('/lists?$queryString');
  }

  // ─── RÉCUPÉRER UNE LISTE PAR ID ──────────────────────
  Future<ApiResponse> getListById(int listId) async {
    return await _api.get('/lists/$listId');
  }

  // ─── METTRE À JOUR UNE LISTE ─────────────────────────
  Future<ApiResponse> updateList(
    int listId, {
    String? title,
    String? description,
    String? status,
    String? dueDate,
    String? dueTime,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (status != null) body['status'] = status;
    if (dueDate != null) body['due_date'] = dueDate;
    if (dueTime != null) body['due_time'] = dueTime;

    return await _api.put('/lists/$listId', body);
  }

  // ─── SUPPRIMER UNE LISTE ─────────────────────────────
  Future<ApiResponse> deleteList(int listId) async {
    return await _api.delete('/lists/$listId');
  }

  // ─── DUPLIQUER UNE LISTE ─────────────────────────────
  Future<ApiResponse> duplicateList(int listId) async {
    return await _api.post('/lists/$listId/duplicate', {});
  }

  // ─── HELPERS : PARSER LES LISTES DEPUIS LA RÉPONSE ───
  /// Parse une liste unique depuis la réponse API
  TaskListModel? parseList(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final listData = response.data!['data']?['list'];
    if (listData == null) return null;
    return TaskListModel.fromJson(listData);
  }

  /// Parse le détail complet d'une liste (avec items + shared_with)
  TaskListModel? parseListDetail(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final data = response.data!['data'];
    if (data == null) return null;

    final listData = data['list'];
    if (listData == null) return null;

    return TaskListModel.fromDetailJson(
      listJson: listData,
      itemsJson: data['items'] as List<dynamic>?,
      sharedWithJson: data['shared_with'] as List<dynamic>?,
    );
  }

  /// Parse une liste de TaskListModel depuis la réponse API
  List<TaskListModel> parseLists(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return [];
    final listsData = response.data!['data']?['lists'];
    if (listsData is! List) return [];
    return listsData
        .map((e) => TaskListModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Parse la pagination depuis la réponse API
  PaginationModel? parsePagination(ApiResponse response) {
    if (!response.isSuccess || response.data == null) return null;
    final paginationData = response.data!['data']?['pagination'];
    if (paginationData == null) return null;
    return PaginationModel.fromJson(paginationData);
  }
}