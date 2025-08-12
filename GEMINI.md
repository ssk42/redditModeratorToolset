# GEMINI.md - Reddit Moderator Toolset

## Project Overview

This project is a cross-platform Reddit moderator toolset designed for speed and efficiency. It consists of two main components:

*   **Flutter Client:** A mobile and desktop application for iOS, Android, macOS, and Windows that provides one-tap access to the mod queue and modmail.
*   **Relay Service:** An optional, lightweight backend service (written in Node.js/NestJS or Go) that provides reliable push notifications, digests, and rate-limit aggregation to reduce client-side battery consumption and API usage.

The architecture is designed as a monorepo, with the Flutter client (`reddit_moderator_toolset/app/`), the Relay service (`reddit_moderator_toolset/relay/`), infrastructure-as-code (`reddit_moderator_toolset/infra/`), and documentation (`reddit_moderator_toolset/docs/`) all located within the `reddit_moderator_toolset/` directory.

## Building and Running

**TODO:** Add specific commands for building, running, and testing the project once they are defined.

The project is a monorepo containing a Flutter application and a backend service. To run the project, you will need to have Flutter, Dart, Go, and Node.js installed.

### Flutter Client

The Flutter client is located in the `reddit_moderator_toolset/app/` directory. To run the client, you will need to have the Flutter SDK installed.

```bash
# Navigate to the client directory
cd reddit_moderator_toolset/app/

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Relay Service

The Relay service can be run using either Go or Node.js.

**Go:**

```bash
# Navigate to the Go relay directory
cd reddit_moderator_toolset/relay/go/

# Install dependencies
go mod tidy

# Run the API server
go run ./cmd/api/

# Run the worker
go run ./cmd/worker/
```

**Node.js:**

```bash
# Navigate to the Node.js relay directory
cd reddit_moderator_toolset/relay/node/

# Install dependencies
npm install

# Run the API server
npm run start:api

# Run the worker
npm run start:worker
```

## Development Conventions

### Flutter
*   **Feature-first modules:** Code is organized by feature in the `features/` directory.
*   **Immutable Models:** [Freezed](https://pub.dev/packages/freezed) is used for creating immutable models, and `json_serializable` for DTOs.
*   **State Management:** [Riverpod](https://riverpod.dev/) is used for state management.
*   **Navigation:** [go_router](https://pub.dev/packages/go_router) is used for navigation and deep linking.
*   **Theming:** A custom theme is defined in `core/theme/`.
*   **Testing:** Tests are written using [Flutter's testing framework](https://docs.flutter.dev/cookbook/testing). Must maintain 75%+ test code coverage.

### Relay Service
*   **Separation of Concerns:** The API and worker have separate entry points but share common libraries for interacting with the Reddit API, sending push notifications, and accessing the database.
*   **Configuration:** Configuration is managed through environment variables (12-factor app methodology).
*   **API Specification:** The API is documented using the OpenAPI specification in `docs/API.md`.
*   **Database Migrations:** Database migrations are handled by `golang-migrate` for Go and Prisma for Node.js.