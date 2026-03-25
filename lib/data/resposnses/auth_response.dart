import '../models/user_model.dart';
import 'api_response.dart';

class AuthResponse {
  final bool isSuccess;
  final String? message;
  final String? errorCode;
  final UserModel? user;
  final String? token;

  AuthResponse._({
    required this.isSuccess,
    this.message,
    this.errorCode,
    this.user,
    this.token,
  });

  /// Parse depuis ApiResponse pour LOGIN et REGISTER
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "message": "Connexion réussie",
  ///   "data": {
  ///     "user": { ... },
  ///     "token": "eyJ..."
  ///   }
  /// }
  factory AuthResponse.fromApiResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return AuthResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      UserModel? user;
      String? token;

      if (data != null) {
        // Parser le user
        if (data['user'] is Map<String, dynamic>) {
          user = UserModel.fromJson(data['user']);
        }

        // Parser le token
        token = data['token']?.toString();
      }

      return AuthResponse._(
        isSuccess: true,
        message: apiResponse.message,
        user: user,
        token: token,
      );
    } catch (e) {
      return AuthResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing de la réponse: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  /// Parse depuis ApiResponse pour PROFILE
  /// Réponse API :
  /// {
  ///   "status": "success",
  ///   "data": {
  ///     "user": { ... }
  ///   }
  /// }
  factory AuthResponse.fromProfileResponse(ApiResponse apiResponse) {
    if (!apiResponse.isSuccess || apiResponse.data == null) {
      return AuthResponse._(
        isSuccess: false,
        message: apiResponse.message ?? 'Erreur inconnue',
        errorCode: apiResponse.errorCode,
      );
    }

    try {
      final data = apiResponse.data!['data'] as Map<String, dynamic>?;

      UserModel? user;
      if (data != null && data['user'] is Map<String, dynamic>) {
        user = UserModel.fromJson(data['user']);
      }

      return AuthResponse._(
        isSuccess: true,
        message: apiResponse.message,
        user: user,
      );
    } catch (e) {
      return AuthResponse._(
        isSuccess: false,
        message: 'Erreur lors du parsing du profil: $e',
        errorCode: 'PARSE_ERROR',
      );
    }
  }

  bool get hasToken => token != null && token!.isNotEmpty;
  bool get hasUser => user != null;

  @override
  String toString() {
    return 'AuthResponse(isSuccess: $isSuccess, message: $message, '
        'hasUser: $hasUser, hasToken: $hasToken)';
  }
}