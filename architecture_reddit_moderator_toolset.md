# Architecture.md — Reddit Moderator Toolset

## 1) Overview
A cross-platform moderator companion for Reddit focused on speed, reliability, and “one-tap” access to the mod queue and modmail. Primary target: **Flutter** for iOS/Android/macOS/Windows. Optional lightweight **Relay Service** supports reliable push notifications, digests, and rate-limit aggregation.

---

## 2) Tiny Relay Service Design
**Purpose**
- Offload polling from client devices to reduce battery drain and API rate-limit issues.
- Provide near real-time push notifications for mod queue/modmail events.
- Generate daily or weekly summaries of mod activity.

**Stack**
- **Runtime:** Node.js (NestJS) or Go.
- **Hosting:** Cloud Run / Fly.io / AWS Lambda + API Gateway.
- **Database:** Postgres (user prefs, device tokens), Redis (caching, rate-limit buckets).
- **Push Providers:** APNs (HTTP/2 token auth), FCM.
- **Secrets:** Cloud KMS for encrypted refresh tokens.

**Flow**
1. **Registration:** Client authenticates with Reddit via OAuth2 PKCE, then registers with Relay by sending device token and selected push filters.
2. **Polling:** Relay polls Reddit APIs every 1–3 minutes (adaptive based on activity) for each registered account.
3. **Event Detection:** Relay compares new results to last poll, filters by user preferences (e.g., only certain subs, only certain report reasons).
4. **Push:** If changes match filters, Relay sends thin push payload with event type + IDs.
5. **Client Fetch:** On receiving push, client calls Reddit API directly to fetch fresh data.

**Security**
- All refresh tokens encrypted at rest (KMS).
- PKCE and HTTPS enforced for all client–relay communications.
- Device token lifecycle management (invalidate on logout).

**Rate Limit Strategy**
- Relay batches polling for multiple users with similar subscriptions.
- Per-user caching to avoid redundant API calls.
- Token bucket system for Reddit API calls.

**Scaling**
- Stateless microservice with horizontal scaling.
- WebSocket channel (optional) for in-app live updates without push.

**MVP Scope**
- User/device registration.
- Reddit polling for mod queue & modmail.
- Push notifications with thin payload.
- Admin dashboard for monitoring relay health.

---

## 3) Client Integration with Relay
- Optional toggle in settings to enable relay-powered push.
- Background fetch fallback if relay disabled.
- Local cache for events to ensure instant UI updates when app opens.

---

## 4) File/Folder Structure
**Monorepo layout for both Flutter client and Relay service:**
```
repo-root/
  client_app/
    lib/
      models/
      services/
      providers/
      views/
      widgets/
      utils/
    test/
    pubspec.yaml
  relay_service/
    api/
      src/
        controllers/
        routes/
        middlewares/
        services/
        models/
      package.json
    worker/
      src/
        pollers/
        processors/
        notifiers/
      package.json
    shared/
      config/
      utils/
    docker/
    tests/
  infra/
    terraform/
    scripts/
  docs/
    Architecture.md
    API.md
```

---

## 5) Database Schema (Postgres)
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    status TEXT CHECK (status IN ('active','unlinked'))
);

CREATE TABLE devices (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    platform TEXT CHECK (platform IN ('ios','android')),
    push_token TEXT NOT NULL,
    last_seen_at TIMESTAMP WITH TIME ZONE,
    relay_jti TEXT
);

CREATE TABLE oauth_tokens (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    provider TEXT DEFAULT 'reddit',
    refresh_token_ciphertext BYTEA NOT NULL,
    scopes TEXT[],
    client_id TEXT NOT NULL,
    PRIMARY KEY (user_id, provider)
);

CREATE TABLE subs (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name CITEXT NOT NULL,
    prefs JSONB,
    last_cursor JSONB,
    last_seen_at TIMESTAMP WITH TIME ZONE,
    PRIMARY KEY (user_id, name)
);

CREATE TABLE notifications_log (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    device_id UUID REFERENCES devices(id) ON DELETE CASCADE,
    type TEXT,
    sub TEXT,
    key TEXT,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);
```

Indexes:
```sql
CREATE INDEX idx_devices_user_id ON devices(user_id);
CREATE INDEX idx_subs_user_id ON subs(user_id);
CREATE UNIQUE INDEX uq_user_sub ON subs(user_id, name);
CREATE INDEX idx_notifications_user ON notifications_log(user_id);
```

---

## 6) Tiny Cloud Relay — Detailed Design (v1.0)
[Section remains as defined in previous version with all subsections 24.1–24.13]



---

## 25) Repos & File/Folder Structure
Goal: quick onboarding, clear ownership, clean separation between **Flutter client** and **Relay**.

### 25.1 Monorepo Layout
```
repo-root/
├─ app/                         # Flutter client (iOS/Android/macOS/Windows)
│  ├─ lib/
│  │  ├─ core/                  # cross-cutting: config, env, logging, errors
│  │  │  ├─ env/
│  │  │  ├─ routing/            # go_router routes
│  │  │  ├─ network/            # dio client, interceptors (auth/retry/rate)
│  │  │  ├─ storage/            # drift db, secure storage wrappers
│  │  │  └─ utils/
│  │  ├─ features/
│  │  │  ├─ auth/               # oauth pkce, onboarding
│  │  │  ├─ home/               # dashboard & counts
│  │  │  ├─ modqueue/           # lists, item cell, actions, bulk
│  │  │  ├─ modmail/            # inbox, thread, composer, labels
│  │  │  ├─ usertools/          # profile, ban/mute, notes
│  │  │  ├─ settings/           # prefs, notifications, templates
│  │  │  └─ widgetsx/           # platform widgets/shortcuts adapters
│  │  ├─ data/                  # repositories, DTOs, mappers
│  │  │  ├─ reddit_api/         # endpoints & models
│  │  │  ├─ relay_api/          # optional relay endpoints
│  │  │  └─ cache/
│  │  ├─ state/                 # Riverpod providers, state notifiers
│  │  └─ app.dart
│  ├─ test/                     # unit/widget/golden tests
│  ├─ integration_test/
│  ├─ assets/                   # icons, lottie, translations
│  ├─ build.yaml                # codegen config (freezed/json/drift)
│  ├─ pubspec.yaml
│  └─ scripts/
│     ├─ generate.sh            # dart run build_runner build --delete-conflicting-outputs
│     └─ format.sh
│
├─ relay/                       # Tiny Cloud Relay service
│  ├─ go/                       # (Option A) Go implementation
│  │  ├─ cmd/
│  │  │  ├─ api/                # REST server main
│  │  │  └─ worker/             # scheduler & pollers main
│  │  ├─ internal/
│  │  │  ├─ api/                # handlers, middlewares
│  │  │  ├─ reddit/             # client, cursors
│  │  │  ├─ push/               # apns, fcm
│  │  │  ├─ store/              # postgres repo, redis rate buckets
│  │  │  ├─ crypto/             # kms envelope, x25519
│  │  │  └─ config/
│  │  ├─ pkg/
│  │  └─ go.mod
│  ├─ node/                     # (Option B) Node.js/NestJS implementation
│  │  ├─ apps/
│  │  │  ├─ api/src/            # controllers, guards, dto
│  │  │  └─ worker/src/         # schedulers, pollers
│  │  ├─ libs/
│  │  │  ├─ reddit/             # SDK
│  │  │  ├─ push/               # apns/fcm clients
│  │  │  ├─ store/              # prisma repos
│  │  │  └─ crypto/             # kms + envelope
│  │  ├─ prisma/
│  │  │  ├─ schema.prisma
│  │  │  └─ migrations/
│  │  ├─ package.json
│  │  └─ tsconfig.json
│  ├─ docker/
│  │  ├─ Dockerfile.api
│  │  ├─ Dockerfile.worker
│  │  └─ compose.dev.yml
│  └─ Makefile
│
├─ infra/
│  ├─ terraform/                # db, kms, run/fly/aca, secrets
│  └─ github-actions/           # CI/CD workflows
│
├─ docs/
│  ├─ Architecture.md           # this document
│  └─ API.md                    # relay REST surface, examples
│
└─ .tool-versions               # asdf (go, node, dart, flutter)
```

### 25.2 Flutter Conventions
- **Feature-first** modules inside `features/` to keep UI + state + data close.
- Use **Freezed** for immutable models; **json_serializable** for DTOs.
- Repositories wrap network/cache; **providers** expose read-only state.
- **App theming**: `core/theme/` with extensions; unit-tested typography/spacing.
- **Navigation**: `go_router` with deep links for modmail threads & sub filters.

### 25.3 Relay Conventions
- Separate **api** and **worker** entry points; both share libs (reddit, push, store).
- 12‑factor config via env; production secrets injected by platform (KMS URIs).
- Use **OpenAPI** spec in `docs/API.md`; generated client used by Flutter `relay_api/`.
- Database migrations: Prisma (Node) or `golang-migrate` (Go).

---

## 26) Database Schema (Postgres)
The relay stores **metadata, device tokens, cursors, and encrypted refresh tokens**; no content bodies. SQL below uses strong constraints + auditing.

```sql
-- 26.1 Extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS citext;

-- 26.2 Core Tables
CREATE TABLE users (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at      timestamptz NOT NULL DEFAULT now(),
  status          text NOT NULL DEFAULT 'active', -- active | unlinked | disabled
  last_login_at   timestamptz
);

CREATE TABLE devices (
  id              uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  platform        text NOT NULL CHECK (platform IN ('ios','android')),
  push_token      text NOT NULL,
  relay_jti       text NOT NULL,              -- JWT id for token revocation
  app_version     text,
  last_seen_at    timestamptz NOT NULL DEFAULT now(),
  created_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, push_token)
);
CREATE INDEX idx_devices_user ON devices(user_id);

CREATE TABLE oauth_tokens (
  user_id                 uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  provider                text NOT NULL DEFAULT 'reddit',
  client_id               text NOT NULL,
  scopes                  text[] NOT NULL,
  refresh_token_cipher    bytea NOT NULL,      -- ciphertext (envelope-encrypted)
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE subs (
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name            citext NOT NULL,             -- e.g., r/Example
  prefs           jsonb NOT NULL DEFAULT '{}', -- per-sub notify rules
  last_cursor     jsonb NOT NULL DEFAULT '{}', -- { modmail: {...}, queue: {...} }
  last_seen_at    timestamptz,
  created_at      timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, name)
);
CREATE INDEX idx_subs_user ON subs(user_id);
CREATE INDEX idx_subs_name ON subs(name);

CREATE TABLE notifications_log (
  id              bigserial PRIMARY KEY,
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  device_id       uuid REFERENCES devices(id) ON DELETE SET NULL,
  type            text NOT NULL,               -- modmail:new | queue:new | digest
  sub             citext,
  key             text NOT NULL,               -- coalescing key: type+sub+window
  payload_meta    jsonb NOT NULL DEFAULT '{}', -- thin info only
  sent_at         timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_notifications_user_time ON notifications_log(user_id, sent_at DESC);

-- Optional: rate buckets persisted (or keep ephemeral in Redis)
CREATE TABLE rate_buckets (
  user_id         uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  window_start    timestamptz NOT NULL,
  tokens_remaining integer NOT NULL,
  PRIMARY KEY (user_id, window_start)
);

-- 26.3 Triggers for updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER oauth_tokens_set_updated
BEFORE UPDATE ON oauth_tokens
FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

-- 26.4 Minimal Seed (for local dev)
INSERT INTO users(id) VALUES (uuid_generate_v4());
```

### 26.5 Prisma Model (Node option)
If you choose Node/Nest + Prisma, the equivalent schema excerpt:
```prisma
model User {
  id            String   @id @default(uuid())
  createdAt     DateTime @default(now())
  status        String   @default("active")
  lastLoginAt   DateTime?
  devices       Device[]
  oauth         OAuthToken?
  subs          Sub[]
}

model Device {
  id         String   @id @default(uuid())
  user       User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId     String
  platform   String
  pushToken  String
  relayJti   String
  appVersion String?
  lastSeenAt DateTime @default(now())
  createdAt  DateTime @default(now())
  @@unique([userId, pushToken])
  @@index([userId])
}

model OAuthToken {
  user       User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId     String   @id
  provider   String   @default("reddit")
  clientId   String
  scopes     String[]
  refreshCipher Bytes
  createdAt  DateTime @default(now())
  updatedAt  DateTime @updatedAt
}

model Sub {
  user       User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId     String
  name       String
  prefs      Json     @default("{}")
  lastCursor Json     @default("{}")
  lastSeenAt DateTime?
  createdAt  DateTime @default(now())
  @@id([userId, name])
  @@index([userId])
  @@index([name])
}

model NotificationLog {
  id        BigInt   @id @default(autoincrement())
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  userId    String
  device    Device?  @relation(fields: [deviceId], references: [id])
  deviceId  String?
  type      String
  sub       String?
  key       String
  payload   Json     @default("{}")
  sentAt    DateTime @default(now())
  @@index([userId, sentAt])
}
```

### 26.6 Migration & Ops Notes
- Apply migrations via CI before deploying new workers.
- Keep **idempotent** backfills for `last_cursor` when adding new sources.
- Rotate relay JWT signing keys quarterly; store public keys for verification.
- **PII review:** tables hold tokens and device identifiers; restrict access; enable row‑level audit logging.

