import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_service.dart';

class _FakeAppAuth extends FlutterAppAuth {
  _FakeAppAuth();
  @override
  Future<AuthorizationTokenResponse?> authorizeAndExchangeCode(
    AuthorizationTokenRequest request,
  ) async {
    // Return null to simulate user cancel or no response; ensures no crash
    return null;
  }
}

class _MemoryStorage extends FlutterSecureStorage {
  final Map<String, String> _m = {};
  _MemoryStorage();
  @override
  Future<void> write({
    required String key,
    String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _m.remove(key);
    } else {
      _m[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _m[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _m.remove(key);
  }
}

void main() {
  test('AuthService signIn completes without error when canceled', () async {
    final auth = AuthService(
      appAuth: _FakeAppAuth(),
      secureStorage: _MemoryStorage(),
    );
    await auth.signIn();
    expect(await auth.getAccessToken(), isNull);
  });

  test('AuthService signOut clears tokens', () async {
    final storage = _MemoryStorage();
    final auth = AuthService(appAuth: _FakeAppAuth(), secureStorage: storage);
    await auth.signIn();
    await auth.signOut();
    expect(await auth.getAccessToken(), isNull);
  });
}
