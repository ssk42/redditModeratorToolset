## Test Coverage Policy

- Minimum coverage: 75% lines for both Flutter and Go modules.
- Enforced in CI via GitHub Actions.

### Flutter
- Run tests with coverage:
  - `flutter test --coverage`
- Coverage file: `coverage/lcov.info`
- CI enforces threshold using `lcov --summary` parsing.

### Go (Relay)
- Run tests with coverage:
  - `cd relay/go && go test -coverprofile=coverage.out ./...`
- Coverage file: `relay/go/coverage.out`
- CI enforces threshold using `go tool cover -func` parsing.

