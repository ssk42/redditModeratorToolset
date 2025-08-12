# Tasks.md — POC Plan for Reddit Moderator Toolset

## Phase 1 — Setup & Foundations
1. **Repo Setup**
   - Create monorepo structure as defined in Architecture.md
   - Configure `.tool-versions` for Go, Node, Dart, Flutter
   - Initialize Flutter app project (`app/`) and Relay service project (`relay/`)

2. **Environment & Tooling**
   - Configure `pubspec.yaml` dependencies (Flutter)
   - Configure Go/Node dependencies for Relay
   - Setup GitHub Actions CI workflows for build & test
   - Add `.editorconfig`, lint rules, and pre-commit hooks

3. **Infrastructure**
   - Provision Postgres (dev/staging)
   - Configure Redis (optional for dev)
   - Create Terraform scripts for DB, KMS, hosting

---

## Phase 2 — Flutter Client Core
4. **Authentication**
   - Implement OAuth2 PKCE flow with Reddit API
   - Store tokens securely (Keychain/Keystore)
   - Basic sign-in/out screens

5. **Navigation & State Management**
   - Implement `go_router` routes
   - Setup Riverpod for global state

6. **UI Foundations**
   - Create base themes (light/dark)
   - Implement reusable UI components (list cells, swipe actions)

7. **Mod Queue MVP**
   - Fetch mod queue items from Reddit API
   - Display in list with approve/remove swipe actions
   - Optimistic UI updates with offline queue

8. **Modmail MVP**
   - Fetch modmail threads from Reddit API
   - Display inbox, view thread, send reply

---

## Phase 3 — Relay Service MVP
9. **API Endpoints**
   - `/devices/register`
   - `/oauth/link`
   - `/prefs` GET/PUT
   - `/debug/test-push`

10. **Database Schema**
    - Apply Postgres schema from Architecture.md
    - Implement migrations (golang-migrate or Prisma)

11. **Polling Worker**
    - Poll mod queue and modmail endpoints per user
    - Track cursors to detect new events
    - Apply filters from prefs

12. **Push Notifications**
    - Integrate with APNs & FCM
    - Send thin payloads with event type & sub

13. **Security**
    - Implement KMS encryption for refresh tokens
    - Validate JWT for all device requests

---

## Phase 4 — Client–Relay Integration
14. **Settings Toggle**
    - Enable/disable Relay in app settings
    - Register device token with Relay

15. **Push Handling**
    - Receive push notification
    - Fetch updated mod queue/modmail from Reddit

16. **Background Fetch Fallback**
    - Implement periodic background fetch if Relay disabled

---

## Phase 5 — Testing & QA
17. **Unit Tests**
    - Flutter: state providers, network services
    - Relay: API handlers, polling logic

18. **Integration Tests**
    - Mock Reddit API for client & relay
    - End-to-end device registration and push flow

19. **Performance & Rate Limits**
    - Verify token bucket rate limiting in Relay
    - Optimize Flutter list performance for large queues

---

## Phase 6 — POC Deployment
20. **Staging Environment**
    - Deploy Relay to Cloud Run/Fly.io
    - Deploy staging Postgres & Redis

21. **App Distribution**
    - Configure Firebase App Distribution / TestFlight
    - Distribute POC to test moderators

22. **Feedback & Iteration**
    - Gather feedback from test users
    - Fix bugs & polish core flows

