import 'package:flutter/material.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _authService.signIn();
          },
          child: const Text('Sign In with Reddit'),
        ),
      ),
    );
  }
}
