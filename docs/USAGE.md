## Using the Reddit Moderator Toolset

### Prerequisites
- Flutter SDK installed
- Create a Reddit OAuth application (installed app)
  - Get Client ID and set a Redirect URI scheme (e.g., `com.example.app:/`)

### Configure OAuth
Provide runtime defines:
```
--dart-define=REDDIT_CLIENT_ID=your_client_id \
--dart-define=REDDIT_REDIRECT_URI=com.example.app:/
```

### Run (examples)
- macOS:
```
flutter run -d macos \
  --dart-define=REDDIT_CLIENT_ID=abc123 \
  --dart-define=REDDIT_REDIRECT_URI=com.example.app:/
```

- iOS (simulator):
```
flutter run -d ios \
  --dart-define=REDDIT_CLIENT_ID=abc123 \
  --dart-define=REDDIT_REDIRECT_URI=com.example.app:/
```

- Android (emulator):
```
flutter run -d android \
  --dart-define=REDDIT_CLIENT_ID=abc123 \
  --dart-define=REDDIT_REDIRECT_URI=com.example.app:/
```

### App Flow
1. Launch app; unauthenticated users are redirected to the Sign In screen.
2. Tap "Sign In with Reddit" to complete OAuth2 PKCE.
3. On success, tokens are stored securely; you land on Home.
4. Use the logout icon in the top-right to Sign Out.

### Testing
- Flutter tests with coverage:
```
flutter test --coverage
```
Coverage report at `coverage/lcov.info`. CI enforces 75%+ minimum.

