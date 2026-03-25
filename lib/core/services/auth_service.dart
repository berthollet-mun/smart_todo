import 'package:get_x/get_core/src/get_main.dart';
import 'package:get_x/get_instance/src/extension_instance.dart';
import 'package:get_x/get_instance/src/lifecycle.dart';
import 'package:smart_todo/data/models/user_model.dart';
import 'package:smart_todo/data/resposnses/api_response.dart';


import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final ApiService _api = Get.find();
  final StorageService _storage = Get.find();

  // ─── REGISTER ─────────────────────────────────────────
  Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/register', {
      'name': name,
      'email': email,
      'password': password,
    });

    if (response.isSuccess && response.data != null) {
      await _saveAuthData(response.data!);
    }

    return response;
  }

  // ─── LOGIN ────────────────────────────────────────────
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.post('/login', {
      'email': email,
      'password': password,
    });

    if (response.isSuccess && response.data != null) {
      await _saveAuthData(response.data!);
    }

    return response;
  }

  // ─── PROFILE ──────────────────────────────────────────
  Future<ApiResponse> getProfile() async {
    final response = await _api.get('/profile');

    if (response.isSuccess && response.data != null) {
      final userData = response.data!['data']?['user'];
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await _storage.saveUser(user);
      }
    }

    return response;
  }

  // ─── LOGOUT ───────────────────────────────────────────
  Future<void> logout() async {
    await _storage.clearAll();
  }

  // ─── HELPERS ──────────────────────────────────────────
  Future<void> _saveAuthData(Map<String, dynamic> responseData) async {
    final data = responseData['data'] as Map<String, dynamic>?;
    if (data == null) return;

    // Sauvegarder le token
    final token = data['token'] as String?;
    if (token != null) {
      await _storage.saveToken(token);
    }

    // Sauvegarder l'utilisateur
    final userData = data['user'] as Map<String, dynamic>?;
    if (userData != null) {
      final user = UserModel.fromJson(userData);
      await _storage.saveUser(user);
    }
  }

  /// Vérifie si l'utilisateur est connecté
  bool get isLoggedIn => _storage.hasToken;

  /// Récupère l'utilisateur actuellement stocké localement
  UserModel? get currentUser => _storage.getUser();
}