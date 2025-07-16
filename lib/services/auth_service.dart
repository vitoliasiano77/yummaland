import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static Future<User?> login(String username, String password) async {
    // --- Logika login admin lokal ---
    if (username == '2311500103' && password == '2311500103') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', 999); // ID fiktif untuk admin lokal
      await prefs.setString('username', '2311500103');
      await prefs.setString('role', 'admin'); // Set role sebagai admin
      return User(id: 999, username: '2311500103', role: 'admin');
    }
    // --- Akhir logika login admin lokal ---

    // --- Logika login user biasa lokal ---
    if (username == 'user23' && password == 'user23') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', 1000); // ID fiktif untuk user biasa lokal
      await prefs.setString('username', 'user23');
      await prefs.setString('role', 'user'); // Set role sebagai user
      return User(id: 1000, username: 'user23', role: 'user');
    }
    // --- Akhir logika login user biasa lokal ---

    try {
      final response = await http.post(
        Uri.parse(Constants.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          final user = User.fromJson(responseData['user']);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('user_id', user.id);
          await prefs.setString('username', user.username);
          await prefs.setString('role', user.role);
          return user;
        } else {
          throw Exception(responseData['message'] ?? 'Login failed: Unknown reason.');
        }
      } else {
        throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in login: $e');
      rethrow;
    }
  }

  static Future<bool> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.registerEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Registration failed: Unknown reason.');
        }
      } else {
        throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in register: $e');
      rethrow;
    }
  }

  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      debugPrint('Error in logout: $e');
      rethrow;
    }
  }

  static Future<String?> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('role');
    } catch (e) {
      debugPrint('Error in getUserRole: $e');
      return null;
    }
  }

  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
    } catch (e) {
      debugPrint('Error in getUserId: $e');
      return null;
    }
  }
}