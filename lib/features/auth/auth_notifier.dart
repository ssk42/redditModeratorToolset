import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_service.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoggedIn = false;

  AuthNotifier(this._authService) {
    _checkLoginStatus();
  }

  bool get isLoggedIn => _isLoggedIn;

  Future<void> _checkLoginStatus() async {
    final accessToken = await _authService.getAccessToken();
    _isLoggedIn = accessToken != null;
    notifyListeners();
  }

  Future<void> signIn() async {
    await _authService.signIn();
    await _checkLoginStatus();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await _checkLoginStatus();
  }
}

final authNotifierProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
