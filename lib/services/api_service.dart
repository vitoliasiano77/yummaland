import 'dart:convert';
import 'package:http/http.dart' as http; // Fixed import
// import 'package:shared_preferences/shared_preferences.dart'; // Removed - Keep if used elsewhere, otherwise remove
import '../models/child.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import 'auth_service.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class ApiService {
  // Removed unused _getToken method

  // Children API Calls
  static Future<bool> addChild(Child child) async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception('User not logged in. Cannot add child.');
    }

    try {
      final response = await http.post(
        Uri.parse(Constants.addChildEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(child.toJson()..['user_id'] = userId), // Add user_id to payload
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error adding child.');
        }
      } else {
        throw Exception('Failed to add child: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in addChild: $e'); // Debugging
      rethrow; // Re-throw the exception after logging
    }
  }

  // Menambahkan parameter userId opsional untuk admin
  static Future<List<Child>> getChildren({String? search, int? userId}) async {
    final currentUserId = await AuthService.getUserId();
    if (currentUserId == null && userId == null) {
      // Jika tidak ada user yang login dan tidak ada userId yang diberikan (misal untuk admin),
      // maka tidak bisa mengambil data anak.
      throw Exception('User not logged in and no specific user ID provided.');
    }

    // Gunakan userId yang diberikan (untuk admin) atau currentUserId (untuk user biasa)
    final targetUserId = userId ?? currentUserId;

    Map<String, String> queryParams = {};
    if (targetUserId != null) {
      queryParams['user_id'] = targetUserId.toString();
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    Uri uri = Uri.parse(Constants.getChildrenEndpoint).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return (responseData['children'] as List)
              .map((json) => Child.fromJson(json))
              .toList();
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error loading children.');
        }
      } else {
        throw Exception('Failed to load children: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in getChildren: $e'); // Debugging
      rethrow;
    }
  }

  static Future<bool> updateChild(Child child) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.updateChildEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(child.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error updating child.');
        }
      } else {
        throw Exception('Failed to update child: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in updateChild: $e'); // Debugging
      rethrow;
    }
  }

  static Future<bool> deleteChild(int childId) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.deleteChildEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': childId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error deleting child.');
        }
      } else {
        throw Exception('Failed to delete child: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in deleteChild: $e'); // Debugging
      rethrow;
    }
  }

  // Payment API Calls
  static Future<bool> processPayment(int childId, String method) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.processPaymentEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'child_id': childId, 'method': method}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error processing payment.');
        }
      } else {
        throw Exception('Failed to process payment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in processPayment: $e'); // Debugging
      rethrow;
    }
  }

  // Admin API Calls
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(Constants.getAllUsersEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return (responseData['users'] as List)
              .map((json) => User.fromJson(json))
              .toList();
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error loading users.');
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in getAllUsers: $e'); // Debugging
      rethrow;
    }
  }

  static Future<bool> updateUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.updateUserEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error updating user.');
        }
      } else {
        throw Exception('Failed to update user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in updateUser: $e'); // Debugging
      rethrow;
    }
  }

  static Future<bool> deleteUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.deleteUserEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error deleting user.');
        }
      } else {
        throw Exception('Failed to delete user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in deleteUser: $e'); // Debugging
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getTopScores() async {
    try {
      final response = await http.get(Uri.parse(Constants.getTopScoresEndpoint));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success']) {
          return (responseData['top_scores'] as List)
              .map((json) => json as Map<String, dynamic>)
              .toList();
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error loading top scores.');
        }
      } else {
        throw Exception('Failed to load top scores: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in getTopScores: $e'); // Debugging
      rethrow;
    }
  }
}