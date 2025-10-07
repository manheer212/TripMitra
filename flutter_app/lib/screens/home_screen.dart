// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services.dart';
import 'results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String _budgetType = 'Low';
  int _days = 1;
  int _people = 1;

  final List<String> _popularDestinations = [
    'Paris', 'Dubai', 'Bali', 'Tokyo', 'London', 'New York', 'Goa', 'Manali', 'Jaipur', 'Singapore', 'Maldives',
  ];

  void _goToResults() {
    if (_destinationController.text.trim().isEmpty || _startController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter start location and destination')),
      );
      return;
    }

    final result = TripService.generateTrip(
      startLocation: _startController.text.trim(),
      destination: _destinationController.text.trim(),
      budgetType: _budgetType,
      days: _days,
    );

    final scaledResult = result.copyWith(
      lowBudget: result.lowBudget.multiply(_people),
      midRange: result.midRange.multiply(_people),
      luxury: result.luxury.multiply(_people),
    );

    Navigator.pushNamed(
      context,
      ResultsScreen.routeName,
      arguments: scaledResult,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('TripMitra'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Plan Your Perfect Trip 🧭',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _startController,
              decoration: const InputDecoration(labelText: 'Start Location', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _destinationController,
              decoration: const InputDecoration(labelText: 'Destination', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Text('Popular Destinations:'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _popularDestinations.map((place) => ActionChip(
                label: Text(place),
                onPressed: () => setState(() => _destinationController.text = place),
                backgroundColor: scheme.primary.withOpacity(0.1),
              )).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Budget Type:'),
            Wrap(
              spacing: 8,
              children: ['Low', 'Middle', 'Rich'].map((budget) => ChoiceChip(
                label: Text(budget),
                selected: _budgetType == budget,
                onSelected: (_) => setState(() => _budgetType = budget),
              )).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of Days:'),
                Row(
                  children: [
                    IconButton(onPressed: () => setState(() { if (_days > 1) _days--; }), icon: const Icon(Icons.remove)),
                    Text('$_days'),
                    IconButton(onPressed: () => setState(() { _days++; }), icon: const Icon(Icons.add)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Number of People:'),
                Row(
                  children: [
                    IconButton(onPressed: () => setState(() { if (_people > 1) _people--; }), icon: const Icon(Icons.remove)),
                    Text('$_people'),
                    IconButton(onPressed: () => setState(() { _people++; }), icon: const Icon(Icons.add)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _goToResults, child: const Text('Generate Trip')),
          ],
        ),
      ),
    );
  }
}
