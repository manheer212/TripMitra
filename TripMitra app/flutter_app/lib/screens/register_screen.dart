// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../api_client.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _usernameController.text.isEmpty) {
      _showSnackbar('All fields are required.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _apiClient.register(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // On successful registration, show success and pop back to login
      if (context.mounted) {
        _showSnackbar('Registration successful. Please log in.');
        Navigator.of(context).pop();
      }
    } catch (e) {
      _showSnackbar('Registration Failed: ${e.toString().split(':').last.trim()}');
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
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Create a TripMitra Account',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
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
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text('Register', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}