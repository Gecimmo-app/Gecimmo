// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = "https://api.saas.test.gecimmo.cloud";

  // Token par défaut utilisé pour les tests / fallback
  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9."
      "eyJ0ZW5hbnRJZCI6IjU4MWFiYTRiLTJiMTMtNDM2Zi1hYjQyLTVjYzUxMmJmOTRiZiIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWVpZGVudGlmaWVyIjoiOTUzMjliMGItZGJiOC00YzAwLThiZGMtNGZlMjIxOTg4ZjAzIiwic3ViIjoiYWRtaW4iLCJqdGkiOiI2Nzk3YjkwYi01MDA4LTRlOGItYTZiMi1iOTNhNjgzMDQ4NWQiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW4iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJTdXBlciBBZG1pbiIsIlBlcm1pc3Npb24iOlsiQWdlbmRhLlNob3ciLCJTeXN0ZW0uTWFuYWdlVXNlcnMiLCJTeXN0ZW0uTWFuYWdlUm9sZXMiLCJMZWFkcy5DcmVhdGUiLCJMZWFkcy5FZGl0IiwiTGVhZHMuRGV0YWlsIiwiTGVhZHMuRGVsZXRlIiwiTGVhZHMuTGlzdCIsIlN5c3RlbS5NYW5hZ2VUZW5hbnRzIiwiTGVhZHMuVHJhaXRlQWxsTGVhZCIsIkxlYWRzLkFkZEZhdm9yaXMiLCJDYW1wYWduZS5DcmVhdGUiLCJMZWFkcy5UcmFpdGVBbGxMZWFkUmVzZXJ2b2lyIiwiTGVhZHMuRGVsZXRlRmF2b3JpcyIsIkNhbXBhZ25lLkVkaXQiLCJMZWFkcy5BY2NlZGVyQVRvdXNMZXNTdGF0dXQiLCJBY3Rpb25zLlJkdiIsIkNhbXBhZ25lLkFkZExldmllciIsIkxlYWRzLlRyYWl0ZUxlYWRXaXRoQWN0aW9uIiwiQWN0aW9ucy5BcHBlbCIsIkNhbXBhZ25lLkVkaXRMZXZpZXIiLCJBY3Rpb25zLlJhcHBlbCIsIkFjdGlvbnMuUmR2U3BvbnRhbmUiLCJDYW1wYWduZS5BZGRTdWl2aSIsIkFjdGlvbnMuUmVqZXRlciIsIkFjdGlvbnMuUmR2UmVwb3J0ZSIsIkNhbXBhZ25lLkVkaXRTdWl2aSIsIkFjdGlvbnMuU3RhdHVlciIsIkFjdGlvbnMuVmlzaXQiLCJDYW1wYWduZS5MaXN0IiwiTGVhZHMuQWRkTm90ZSIsIkFjdGlvbnMuSG9ub3JlIiwiQWN0aW9ucy5SZWFsaXNlVGFjaGUiLCJMZWFkcy5VcGRhdGVJbnRlcmV0IiwiQWN0aW9ucy5UZW1wb3Jpc2UiXSwiZXhwIjoxNzc2MTE1NjE4LCJpc3MiOiJodHRwczovL0dDU0FBUy5nZWNpbW1vLmNsb3VkLyIsImF1ZCI6IkdDLVNBQVMifQ."
      "4_UHl5Pj-gVfe-QBreyMo_YC87kfvTJ0mMBmakx0ik0";

  // Headers réutilisables
  static Map<String, String> get _headers {
    final token = AuthService().token;
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  /// Traitement centralisé des réponses avec gestion d'erreurs détaillée
  static dynamic _processResponse(http.Response response, String endpoint) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    // Tentative d'extraction du message d'erreur du serveur
    String errorMessage = "Erreur ${response.statusCode}";
    try {
      final body = jsonDecode(response.body);
      errorMessage = body['message'] ?? body['error'] ?? body['title'] ?? errorMessage;
    } catch (_) {}

    throw Exception("$endpoint : $errorMessage");
  }

  // 🔑 Login avec username / password
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return _processResponse(response, "/api/auth/login") as Map<String, dynamic>;
  }

  // 📦 Récupérer les leads
  static Future<dynamic> getLeads() async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/leads"),
      headers: _headers,
    );
    return _processResponse(response, "/api/leads");
  }

  // 📋 Requête GET
  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
    );
    return _processResponse(response, endpoint);
  }

  // 📤 Requête POST
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _processResponse(response, endpoint);
  }

  // 🔄 Requête PUT
  static Future<dynamic> put(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _processResponse(response, endpoint);
  }

  // 📝 Requête PATCH
  static Future<dynamic> patch(
      String endpoint, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _processResponse(response, endpoint);
  }

  // 🗑️ Requête DELETE
  static Future<dynamic> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: _headers,
    );
    return _processResponse(response, endpoint);
  }
}
