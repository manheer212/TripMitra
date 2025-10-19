// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../api_client.dart';
import 'home_screen.dart';
import 'register_screen.dart'; // To navigate to the registration page

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _emailController = TextEditingController(text: 'placeholder@tripmitra.com');
  final TextEditingController _passwordController = TextEditingController(text: 'temporary_password');
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar('Please enter email and password.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiClient.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // On successful login, navigate to the Home Screen
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    } catch (e) {
      _showSnackbar('Login Failed: ${e.toString().split(':').last.trim()}');
    } finally {
      if (context.mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome Back to TripMitra',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text('Log In', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.routeName);
                },
                child: const Text("Don't have an account? Register Here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}