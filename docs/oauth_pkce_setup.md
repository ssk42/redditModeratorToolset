## OAuth2 PKCE Setup (Reddit)

1. Create a Reddit OAuth app (installed app).
   - Redirect URI: `com.example.app:/` (or your custom scheme)
   - Scopes: `identity`, `modmail`, `modconfig`, `modposts`, `modflair`, `read`

2. Provide secrets at runtime using Dart defines:
   - `--dart-define=REDDIT_CLIENT_ID=your_client_id`
   - `--dart-define=REDDIT_REDIRECT_URI=your_scheme:/`

3. iOS setup:
   - Configure URL Types for the scheme in Xcode (Info tab) matching the redirect URI.

4. Android setup:
   - Add intent-filter for the scheme/host in `AndroidManifest.xml`.

5. Local run example:
```
flutter run -d macos \
  --dart-define=REDDIT_CLIENT_ID=abc123 \
  --dart-define=REDDIT_REDIRECT_URI=com.example.app:/
```

