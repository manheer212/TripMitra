import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/results_screen.dart';

void main() => runApp(const TripMitraApp());

class TripMitraApp extends StatelessWidget {
  const TripMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripMitra',
      theme: ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        ResultsScreen.routeName: (_) => const ResultsScreen(),
      },
    );
  }
}
