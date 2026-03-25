class PaginationModel {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page']?.toString() ?? '20') ?? 20,
      totalItems: json['total_items'] is int
          ? json['total_items']
          : int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      totalPages: json['total_pages'] is int
          ? json['total_pages']
          : int.tryParse(json['total_pages']?.toString() ?? '1') ?? 1,
      hasNext: json['has_next'] == true || json['has_next'] == 1,
      hasPrev: json['has_prev'] == true || json['has_prev'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total_items': totalItems,
      'total_pages': totalPages,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }

  bool get isFirstPage => currentPage == 1;
  bool get isLastPage => currentPage == totalPages;

  @override
  String toString() =>
      'PaginationModel(page: $currentPage/$totalPages, total: $totalItems)';
}