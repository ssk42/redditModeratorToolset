# Reddit Moderator Toolset

Cross-platform moderator companion for Reddit with an optional Relay service for reliable push and polling aggregation.

## Project Layout
- Flutter app at repo root: `lib/`, `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/`
- Relay (Go) at `relay/go`
- Docs at `docs/`
- CI workflows at `.github/workflows/`

See `architecture_reddit_moderator_toolset.md` for full architecture and `Tasks.md` for the POC plan.

## Flutter
- Install deps: `flutter pub get`
- Analyze: `flutter analyze`
- Test: `flutter test`
- Run (macOS): `flutter run -d macos`

Auth uses `flutter_appauth` + `flutter_secure_storage`. Update `features/auth/auth_service.dart` with your Reddit OAuth client ID and redirect URI before signing in.

## Relay (Go)
- Build: `cd relay/go && go build ./...`
- Test: `cd relay/go && go test ./...`
- Run API locally: `cd relay/go && go run ./cmd/api`
  - Health check: `curl http://localhost:8080/healthz`

## CI
GitHub Actions are configured for Flutter and the Go relay in `.github/workflows/`.

E2E browser smoke tests (Playwright) are available under `e2e/` and run in CI.
To run locally:
```
cd e2e && npm install && npx playwright install --with-deps && npx playwright test
```

## Diagrams
See `docs/architecture_overview.mmd` for the Mermaid diagram of the system.
