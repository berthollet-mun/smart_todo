import 'dart:convert';

import 'package:get_x/get_instance/src/lifecycle.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ─── TOKEN ────────────────────────────────────────────
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  bool get hasToken => _prefs.containsKey(_tokenKey);

  // ─── USER ─────────────────────────────────────────────
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, json.encode(user.toJson()));
  }

  UserModel? getUser() {
    final data = _prefs.getString(_userKey);
    if (data == null) return null;
    try {
      return UserModel.fromJson(json.decode(data));
    } catch (_) {
      return null;
    }
  }

  Future<void> removeUser() async {
    await _prefs.remove(_userKey);
  }

  // ─── CLEAR ALL ────────────────────────────────────────
  Future<void> clearAll() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userKey);
  }
}