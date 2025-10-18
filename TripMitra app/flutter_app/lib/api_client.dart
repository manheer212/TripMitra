// TripMitra app/flutter_app/lib/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiClient {
  // IMPORTANT: For local development:
  // - 'http://10.0.2.2:33400' is required for Android Emulators to reach your host machine's localhost.
  // - 'http://localhost:33400' works for iOS simulator, web, and desktop.
  // Once deployed, this URL MUST be changed to your public HTTPS domain (e.g., 'https://api.tripmitra.com').
  static const String baseUrl = kIsWeb
      ? 'http://localhost:33400'
      : 'http://10.0.2.2:33400'; 

  Future<Map<String, dynamic>> getTripPlan({	
  required String startLocation,	
  required String destination,	
  required int days,	
  required int people,	
  required bool domestic,	
  required String budgetType, // <--- ADD THIS PARAMETER	
}) async {	
  final Map<String, String> queryParams = {	
'start_location': startLocation,	
'destination': destination,	
'days': days.toString(),	
'people': people.toString(),	
'domestic': domestic.toString(),	
'budget_type': budgetType, // <--- ADD THIS TO QUERY PARAMS	
};

    final uri = Uri.parse('$baseUrl/balance').replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        debugPrint('API Call Failed: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
        throw Exception('Failed to load trip plan: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Network Error: $e');
      throw Exception('Network or API connection error. Is the Python server running on $baseUrl?');
    }
  }
}