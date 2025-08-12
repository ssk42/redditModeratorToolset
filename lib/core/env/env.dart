class Env {
  // Provide via --dart-define=REDDIT_CLIENT_ID=... at build/run time
  static const redditClientId = String.fromEnvironment(
    'REDDIT_CLIENT_ID',
    defaultValue: 'CHANGE_ME_CLIENT_ID',
  );

  // Provide via --dart-define=REDDIT_REDIRECT_URI=... at build/run time
  static const redditRedirectUri = String.fromEnvironment(
    'REDDIT_REDIRECT_URI',
    defaultValue: 'com.example.app:/',
  );

  // Optional toggle for using the relay
  static const useRelay = bool.fromEnvironment(
    'USE_RELAY',
    defaultValue: false,
  );
}
