import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _secureStorage;

  const AuthService({
    FlutterAppAuth? appAuth,
    FlutterSecureStorage? secureStorage,
  }) : _appAuth = appAuth ?? const FlutterAppAuth(),
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  Future<void> signIn() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth
          .authorizeAndExchangeCode(
            AuthorizationTokenRequest(
              'd3dJ2g8v3f4c1A', // TODO: Replace with your client ID
              'com.example.app:/', // TODO: Replace with your redirect URI
              serviceConfiguration: const AuthorizationServiceConfiguration(
                authorizationEndpoint:
                    'https://www.reddit.com/api/v1/authorize.compact',
                tokenEndpoint: 'https://www.reddit.com/api/v1/access_token',
              ),
              scopes: ['identity', 'modmail', 'modqueue'],
            ),
          );

      if (result != null) {
        await _secureStorage.write(
          key: 'access_token',
          value: result.accessToken,
        );
        await _secureStorage.write(
          key: 'refresh_token',
          value: result.refreshToken,
        );
        await _secureStorage.write(key: 'id_token', value: result.idToken);
      }
    } catch (e) {
      debugPrint('Auth signIn error: $e');
    }
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
    await _secureStorage.delete(key: 'id_token');
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }
}
