import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = 'http://10.0.2.2:5207/api'; // For Android emulator
  // static const String baseUrl = 'http://localhost:5207/api'; // For iOS/Web
  
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _storage.write(key: 'jwt_token', value: authResponse.token);
      return authResponse;
    } else {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<void> register(String email, String password, String fullName, {String role = 'User'}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body));
    }
  }

  Future<List<User>> getUsers() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<String>> getRoles() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse('$baseUrl/roles'), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((role) => role['name'].toString()).toList();
    } else {
      throw Exception('Failed to load roles');
    }
  }

  Future<void> createRole(String roleName) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/roles'),
      headers: headers,
      body: jsonEncode(roleName),
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body));
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/account/change-password'),
      headers: headers,
      body: jsonEncode({'currentPassword': currentPassword, 'newPassword': newPassword}),
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body));
  }

  Future<void> updateProfile(String fullName) async {
    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/account/update-profile'),
      headers: headers,
      body: jsonEncode({'fullName': fullName}),
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body));
  }

  Future<void> assignRole(String userId, String roleName) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/roles/assign?userId=$userId&roleName=$roleName'),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body));
  }

  Future<void> deleteAccount() async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/account/delete-account'),
      headers: headers,
    );
    if (response.statusCode != 200) throw Exception(jsonDecode(response.body));
    await logout();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
