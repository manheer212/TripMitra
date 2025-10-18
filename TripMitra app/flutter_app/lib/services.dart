// lib/services.dart
import 'models.dart';
import 'api_client.dart'; // Import the new API Client for network calls
// dart:math and the old mock logic have been removed

class TripService {
  // Static instance of the API client
  static final ApiClient _apiClient = ApiClient();

  // Change to an asynchronous method to fetch data from the backend
  static Future<GenerateResult> generateTrip({
    required String startLocation,
    required String destination,
    required String budgetType,
    required int days,
    required int people, // Added: To support person-scaling on backend
    required bool domestic, // Added: To support domestic/international cost logic on backend
  }) async {

    // 1. Fetch data from Python backend via the API client
    final jsonResponse = await _apiClient.getTripPlan(
      startLocation: startLocation,
      destination: destination,
      days: days,
      people: people,
      domestic: domestic,
      budgetType: budgetType, // **CRITICAL FIX**: Passing budgetType
    );

    // 2. Parse the result into the Flutter model
    // The implementation of fromBackendJson must be in your models.dart file
    final result = GenerateResult.fromBackendJson(jsonResponse, destination);

    return result;
  }
}