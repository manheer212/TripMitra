// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../services.dart';
import 'results_screen.dart';
import 'login_screen.dart'; // Import for navigation

class HomeScreen extends StatefulWidget {
  // Define a name for routing from main.dart
  static const routeName = '/home'; 
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiClient _apiClient = ApiClient();
  // Controllers
  final TextEditingController _startController = TextEditingController(text: 'Delhi');
  final TextEditingController _destinationController = TextEditingController(text: 'Goa');
  // State variables
  String _budgetType = 'Low';
  int _days = 3;
  int _people = 1;
  bool _isLoading = false;
  bool _domestic = true;
  String? _currentUserId; // To hold the authenticated user ID

  final List<String> _popularDestinations = [
    'Paris', 'Dubai', 'Bali', 'Tokyo', 'London', 'New York', 'Goa', 'Manali', 'Jaipur', 'Singapore', 'Maldives',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  // Load the authenticated User ID from secure storage on app start
  Future<void> _loadUserId() async {
    final userId = await _apiClient.storage.read(key: 'user_id');
    setState(() {
      _currentUserId = userId;
    });
  }

  Future<void> _logout() async {
    await _apiClient.deleteToken();
    await _apiClient.storage.delete(key: 'user_id'); // Clear the stored user ID
    if (context.mounted) {
      // Navigate to Login screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
    }
  }

  Future<void> _goToResults() async {
    if (_destinationController.text.trim().isEmpty || _startController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter start location and destination')),
      );
      return;
    }
    
    // IMPORTANT: In a real app, we would block or redirect if _currentUserId is null
    // Since we are moving forward, we'll continue using the ID retrieved (which is "1" after initial manual setup)

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await TripService.generateTrip(
        startLocation: _startController.text.trim(),
        destination: _destinationController.text.trim(),
        budgetType: _budgetType, 
        days: _days,
        people: _people,
        domestic: _domestic, 
      );
      
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          ResultsScreen.routeName,
          arguments: result,
        );
      }
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating trip: ${e.toString().split(':').last.trim()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TripMitra'), 
        centerTitle: true,
        actions: [
          // Display a loading indicator if needed
          if (_isLoading) 
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
          
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Plan Your Perfect Trip 🧭',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Show the current user for confirmation
            Text('Current User ID: ${_currentUserId ?? 'Not Logged In'}'), 
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