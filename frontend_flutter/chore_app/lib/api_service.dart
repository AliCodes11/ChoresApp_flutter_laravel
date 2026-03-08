import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IMPORTANT:
  // Replace this if your computer IP changes.
  static const String baseUrl = 'http://172.20.10.5:8000/api';

  static Uri _uri(String path, [Map<String, dynamic>? queryParams]) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParams == null || queryParams.isEmpty) return uri;

    final filtered = queryParams.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return uri.replace(queryParameters: filtered);
  }

  static Map<String, String> jsonHeaders({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // =========================
  // AUTH
  // =========================

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      _uri('/register'),
      headers: jsonHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      _uri('/login'),
      headers: jsonHeaders(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      _uri('/user'),
      headers: jsonHeaders(token: token),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> logout(String token) async {
    final response = await http.post(
      _uri('/logout'),
      headers: jsonHeaders(token: token),
    );

    return _handleResponse(response);
  }

  // =========================
  // CHORES
  // =========================

  static Future<List<dynamic>> getChores(
    String token, {
    String? filter,
    String? search,
  }) async {
    final query = <String, dynamic>{};

    if (filter != null && filter.isNotEmpty && filter != 'all') {
      query['filter'] = filter;
    }

    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    final response = await http.get(
      _uri('/chores', query),
      headers: jsonHeaders(token: token),
    );

    final data = _handleResponse(response);
    final chores = data['chores'];

    if (chores is List) {
      return chores;
    }

    return [];
  }

  static Future<Map<String, dynamic>> getChore({
    required String token,
    required int choreId,
  }) async {
    final response = await http.get(
      _uri('/chores/$choreId'),
      headers: jsonHeaders(token: token),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> createChore({
    required String token,
    required String title,
    required String description,
    required DateTime expiresAt,
  }) async {
    final response = await http.post(
      _uri('/chores'),
      headers: jsonHeaders(token: token),
      body: jsonEncode({
        'title': title,
        'description': description,
        'expires_at': expiresAt.toIso8601String(),
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> updateChore({
    required String token,
    required int choreId,
    required String title,
    required String description,
    required DateTime expiresAt,
    required bool isDone,
  }) async {
    final response = await http.put(
      _uri('/chores/$choreId'),
      headers: jsonHeaders(token: token),
      body: jsonEncode({
        'title': title,
        'description': description,
        'expires_at': expiresAt.toIso8601String(),
        'is_done': isDone,
      }),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> deleteChore({
    required String token,
    required int choreId,
  }) async {
    final response = await http.delete(
      _uri('/chores/$choreId'),
      headers: jsonHeaders(token: token),
    );

    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> markChoreDone({
    required String token,
    required int choreId,
  }) async {
    final response = await http.patch(
      _uri('/chores/$choreId/done'),
      headers: jsonHeaders(token: token),
    );

    return _handleResponse(response);
  }

  // =========================
  // INTERNAL RESPONSE HANDLER
  // =========================

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decoded =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {'data': decoded};
    }

    if (decoded is Map<String, dynamic>) {
      // Laravel validation errors often come in "errors"
      if (decoded['errors'] is Map) {
        final errors = decoded['errors'] as Map;
        final firstField = errors.values.isNotEmpty ? errors.values.first : null;

        if (firstField is List && firstField.isNotEmpty) {
          throw Exception(firstField.first.toString());
        }
      }

      final message = decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          'Request failed with status ${response.statusCode}';

      throw Exception(message);
    }

    throw Exception('Request failed with status ${response.statusCode}');
  }
}