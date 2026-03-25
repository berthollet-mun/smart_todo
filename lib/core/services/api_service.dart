import 'dart:convert';


import 'package:get_x/get_core/src/get_main.dart';
import 'package:get_x/get_instance/src/extension_instance.dart';
import 'package:get_x/get_instance/src/lifecycle.dart';
import 'package:http/http.dart' as http;
import 'package:smart_todo/data/resposnses/api_response.dart';

import 'storage_service.dart';

class ApiService extends GetxService {
  static const String baseUrl = 'https://smart-do.jobyrdc.com/api';
  final StorageService _storageService = Get.find();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storageService.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ─── GET ──────────────────────────────────────────────
  Future<ApiResponse> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(
        'Erreur de connexion: $e',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // ─── POST ─────────────────────────────────────────────
  Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(
        'Erreur de connexion: $e',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // ─── PUT ──────────────────────────────────────────────
  Future<ApiResponse> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(
        'Erreur de connexion: $e',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // ─── PATCH ────────────────────────────────────────────
  Future<ApiResponse> patch(String endpoint,
      [Map<String, dynamic>? data]) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
        body: data != null ? json.encode(data) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(
        'Erreur de connexion: $e',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // ─── DELETE ───────────────────────────────────────────
  Future<ApiResponse> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: await _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      return ApiResponse.error(
        'Erreur de connexion: $e',
        code: 'NETWORK_ERROR',
      );
    }
  }

  // ─── RESPONSE HANDLER ────────────────────────────────
  ApiResponse _handleResponse(http.Response response) {
    print('=== API RESPONSE ===');
    print('URL: ${response.request?.url}');
    print('Method: ${response.request?.method}');
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    print('====================');

    if (response.body.isEmpty) {
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(message: 'OK', data: {});
      }
      return ApiResponse.error(
        'Erreur serveur (${response.statusCode})',
        code: 'EMPTY_RESPONSE',
      );
    }

    final rawBody = response.body.trim();
    final looksLikeHtml = rawBody.startsWith('<!DOCTYPE html') ||
        rawBody.startsWith('<html') ||
        rawBody.startsWith('<br') ||
        rawBody.contains('Fatal error');

    if (looksLikeHtml) {
      return ApiResponse.error(
        'Erreur backend PHP renvoyée en HTML.',
        code: 'BACKEND_PHP_ERROR',
      );
    }

    try {
      final dynamic decoded = json.decode(response.body);
      final Map<String, dynamic> data = decoded is Map<String, dynamic>
          ? decoded
          : <String, dynamic>{'data': decoded};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final String? msg = data['message']?.toString();
        return ApiResponse.success(message: msg, data: data);
      } else {
        String error =
            (data['message'] ?? data['error'] ?? 'Erreur inconnue').toString();

        // Extraire la première erreur de validation si présente
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final firstVal = errors.values.first;
            if (firstVal is List && firstVal.isNotEmpty) {
              error = firstVal.first.toString();
            }
          }
        }

        return ApiResponse.error(
          error,
          code: 'HTTP_${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        'Réponse serveur invalide (JSON)',
        code: 'PARSE_ERROR',
      );
    }
  }
}