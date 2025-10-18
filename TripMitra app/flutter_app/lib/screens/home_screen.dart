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
  final TextEditingController _startController = TextEditingController(text: 'Delhi');
  final TextEditingController _destinationController = TextEditingController(text: 'Goa');
  String _budgetType = 'Low';
  int _days = 3;
  int _people = 1;
  bool _isLoading = false; // State variable for loading
  
  // Adding default domestic status
  bool _domestic = true;

  final List<String> _popularDestinations = [
    'Paris', 'Dubai', 'Bali', 'Tokyo', 'London', 'New York', 'Goa', 'Manali', 'Jaipur', 'Singapore', 'Maldives',
  ];

  Future<void> _goToResults() async {
    if (_destinationController.text.trim().isEmpty || _startController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter start location and destination')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await TripService.generateTrip(
        startLocation: _startController.text.trim(),
        destination: _destinationController.text.trim(),
        budgetType: _budgetType, // Passed for potential future use or server logging
        days: _days,
        people: _people,
        domestic: _domestic, // Pass domestic flag
      );
      
      // Since scaling is done on the backend now, we just pass the result.
      Navigator.pushNamed(
        context,
        ResultsScreen.routeName,
        arguments: result,
      );
      
    } catch (e) {
      // Handle the error (e.g., network error/404)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating trip: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                onPressed: () {
                  setState(() => _destinationController.text = place);
                  // Simple check: Domestic if start and destination are Indian cities
                  if (['Goa', 'Manali', 'Jaipur'].contains(_startController.text) && ['Goa', 'Manali', 'Jaipur'].contains(place)) {
                    _domestic = true;
                  } else {
                    _domestic = false;
                  }
                },
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
            ElevatedButton(
              onPressed: _isLoading ? null : _goToResults,
              child: _isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                  : const Text('Generate Trip')
            ),
          ],
        ),
      ),
    );
  }
}