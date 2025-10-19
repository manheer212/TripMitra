// TripMitra app/flutter_app/lib/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 

class ApiClient {
  static const String baseUrl = kIsWeb
      ? 'http://localhost:33400' 
      : defaultTargetPlatform == TargetPlatform.android 
          ? 'http://10.0.2.2:33400' 
          : 'http://localhost:33400';

  final storage = const FlutterSecureStorage();

  // Retrieves the Authorization header and Content-Type
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await storage.read(key: 'jwt');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // Helper methods to store and delete the JWT
  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'user_id'); // Also clear the user ID
  }

  // === NEW AUTHENTICATION METHODS ===

  Future<void> register({required String username, required String email, required String password}) async {
    final uri = Uri.parse('$baseUrl/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode != 201) {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Registration failed.');
    }
  }

  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final uri = Uri.parse('$baseUrl/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Store the token and user ID securely
      await saveToken(data['token']);
      await storage.write(key: 'user_id', value: data['user_id'].toString());
      
      return data;
    } else {
      final data = json.decode(response.body);
      throw Exception(data['error'] ?? 'Login failed.');
    }
  }

  // === EXISTING TRIP PLANNER METHOD ===

  Future<Map<String, dynamic>> getTripPlan({
    required String startLocation,
    required String destination,
    required int days,
    required int people,
    required bool domestic,
    required String budgetType,
  }) async {
    // Read user ID from storage to send to the backend for linking the trip
    final userId = await storage.read(key: 'user_id');
    
    final Map<String, String> queryParams = {
      // NOTE: We don't typically send user_id as a query param, but it's the fastest way for your current Flask setup.
      'user_id': userId ?? '1', // Fallback to '1' if somehow missing (shouldn't happen if logged in)
      'start_location': startLocation,
      'destination': destination,
      'days': days.toString(),
      'people': people.toString(),
      'domestic': domestic.toString(),
      'budget_type': budgetType,
    };

    final uri = Uri.parse('$baseUrl/balance').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: await _getAuthHeaders());

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('API Call Failed: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        // Check for 401 Unauthorized here if needed in a more complex setup
        throw Exception('Failed to load trip plan: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      throw Exception('Network or API connection error. Is the Python server running on $baseUrl?');
    }
  }
}