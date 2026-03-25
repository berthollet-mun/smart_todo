class ApiResponse {
  final bool isSuccess;
  final String? message;
  final Map<String, dynamic>? data;
  final String? errorCode;

  ApiResponse._({
    required this.isSuccess,
    this.message,
    this.data,
    this.errorCode,
  });

  factory ApiResponse.success({
    String? message,
    Map<String, dynamic>? data,
  }) {
    return ApiResponse._(
      isSuccess: true,
      message: message,
      data: data,
    );
  }

  factory ApiResponse.error(
    String message, {
    String? code,
  }) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      errorCode: code,
    );
  }

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, message: $message, '
        'errorCode: $errorCode, data: $data)';
  }
}