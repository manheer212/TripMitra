// lib/services.dart
import 'models.dart';
import 'dart:math';

class TripService {
  static GenerateResult generateTrip({
    required String startLocation,
    required String destination,
    required String budgetType,
    required int days,
  }) {
    final lowBudgetDestinations = [
      {'name': 'Manali', 'days': 4, 'description': 'Budget-friendly hill station'},
      {'name': 'Rishikesh', 'days': 3, 'description': 'Yoga & river rafting'},
      {'name': 'Jaipur', 'days': 3, 'description': 'Historic forts & markets'},
    ];

    double rand(double min, double max) => min + Random().nextDouble() * (max - min);

    // Domestic travel cost (Bus/Train)
    double travelCostLow = startLocation != destination ? rand(5, 20) : 0;
    double travelCostMid = startLocation != destination ? rand(20, 50) : 0;

    final lowBudget = BudgetPlan(
      flights: 0, // use bus/train
      lodging: rand(20, 50) * days,
      localTransport: rand(5, 15) * days + travelCostLow,
      activities: rand(10, 25) * days,
      food: rand(10, 20) * days,
    );

    final midBudget = BudgetPlan(
      flights: 0, // low domestic flights optional
      lodging: rand(50, 120) * days,
      localTransport: rand(15, 30) * days + travelCostMid,
      activities: rand(25, 50) * days,
      food: rand(20, 40) * days,
    );

    final luxuryBudget = BudgetPlan(
      flights: rand(300, 600) * days,
      lodging: rand(150, 400) * days,
      localTransport: rand(30, 70) * days,
      activities: rand(50, 150) * days,
      food: rand(40, 100) * days,
    );

    List<ItineraryDay> itinerary = List.generate(days, (i) {
      final date = DateTime.now().add(Duration(days: i));
      return ItineraryDay(
        date: date,
        area: '$destination - Day ${i + 1}',
        items: [
          ItineraryItem(
            poi: POI(name: 'Sightseeing Spot ${i + 1}', category: 'Sightseeing'),
            start: DateTime(date.year, date.month, date.day, 9, 0),
            end: DateTime(date.year, date.month, date.day, 12, 0),
            transport: 'Bus',
            costEstimate: budgetType == 'Low' ? rand(0, 5) : rand(5, 50),
          ),
          ItineraryItem(
            poi: POI(name: 'Local Restaurant', category: 'Food'),
            start: DateTime(date.year, date.month, date.day, 13, 0),
            end: DateTime(date.year, date.month, date.day, 14, 0),
            transport: 'Walk',
            costEstimate: budgetType == 'Low' ? rand(5, 15) : rand(15, 50),
          ),
          ItineraryItem(
            poi: POI(name: 'Activity ${i + 1}', category: 'Adventure'),
            start: DateTime(date.year, date.month, date.day, 15, 0),
            end: DateTime(date.year, date.month, date.day, 17, 0),
            transport: 'Taxi',
            costEstimate: budgetType == 'Low' ? rand(0, 10) : rand(20, 80),
          ),
        ],
      );
    });

    return GenerateResult(
      lowBudget: lowBudget,
      midRange: midBudget,
      luxury: luxuryBudget,
      itinerary: itinerary,
      lowBudgetDestinations: lowBudgetDestinations,
    );
  }
}
