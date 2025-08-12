import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateProvider = FutureProvider<String?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getAccessToken();
});
