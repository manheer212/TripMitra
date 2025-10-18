// lib/models.dart
// ignore: unused_import
import 'package:flutter/foundation.dart';

class BudgetPlan {
  final double flights;
  final double lodging;
  final double localTransport;
  final double activities;
  final double food;
  final double buffer;

  BudgetPlan({
    required this.flights,
    required this.lodging,
    required this.localTransport,
    required this.activities,
    required this.food,
  }) : buffer = 0.1 * (flights + lodging + localTransport + activities + food);

  double get total => flights + lodging + localTransport + activities + food + buffer;

  /// Multiply budget by number of people
  BudgetPlan multiply(int people) {
    return BudgetPlan(
      flights: flights * people,
      lodging: lodging * people,
      localTransport: localTransport * people,
      activities: activities * people,
      food: food * people,
    );
  }
}

class POI {
  final String name;
  final String category;
  POI({required this.name, required this.category});
}

class ItineraryItem {
  final POI poi;
  final DateTime start;
  final DateTime end;
  final String transport;
  final double costEstimate;
  ItineraryItem({
    required this.poi,
    required this.start,
    required this.end,
    required this.transport,
    required this.costEstimate,
  });
}

class ItineraryDay {
  final DateTime date;
  final String area;
  final List<ItineraryItem> items;
  ItineraryDay({
    required this.date,
    required this.area,
    required this.items,
  });
}

class GenerateResult {
  final BudgetPlan lowBudget;
  final BudgetPlan midRange;
  final BudgetPlan luxury;
  final List<ItineraryDay> itinerary;
  final List<Map<String, dynamic>> lowBudgetDestinations;

  GenerateResult({
    required this.lowBudget,
    required this.midRange,
    required this.luxury,
    required this.itinerary,
    required this.lowBudgetDestinations,
  });

  /// CopyWith for immutability
  GenerateResult copyWith({
    BudgetPlan? lowBudget,
    BudgetPlan? midRange,
    BudgetPlan? luxury,
    List<ItineraryDay>? itinerary,
    List<Map<String, dynamic>>? lowBudgetDestinations,
  }) {
    return GenerateResult(
      lowBudget: lowBudget ?? this.lowBudget,
      midRange: midRange ?? this.midRange,
      luxury: luxury ?? this.luxury,
      itinerary: itinerary ?? this.itinerary,
      lowBudgetDestinations: lowBudgetDestinations ?? this.lowBudgetDestinations,
    );
  }

  static fromBackendJson(Map<String, dynamic> jsonResponse, String destination) {}
}
