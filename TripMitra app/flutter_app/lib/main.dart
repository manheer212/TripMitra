import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';
import 'screens/login_screen.dart'; // NEW
import 'screens/register_screen.dart'; // NEW
import 'api_client.dart'; // NEW

void main() => runApp(const TripMitraApp());

class TripMitraApp extends StatelessWidget {
  const TripMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripMitra',
      theme: ThemeData.light(),
      // Initial route now points to the checker widget
      initialRoute: '/', 
      routes: {
        '/': (_) => const CheckAuthStatus(), // Check login status first
        HomeScreen.routeName: (_) => const HomeScreen(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ResultsScreen.routeName: (_) => const ResultsScreen(),
      },
    );
  }
}

// NEW: Widget to check if the JWT token exists on launch
class CheckAuthStatus extends StatelessWidget {
  const CheckAuthStatus({super.key});

  Future<bool> _isLoggedIn() async {
    final token = await ApiClient().storage.read(key: 'jwt');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a splash screen or loading indicator while checking
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        // If snapshot data is true (logged in), navigate to Home. Otherwise, Login.
        if (snapshot.data == true) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}