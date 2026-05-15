# TindahanNatin

TindahanNatin is a multi-project workspace made up of an Aspire AppHost, an ASP.NET Core backend, and a Flutter client.

## Repository Structure

```text
.
├── TindahanNatin.AppHost/   # Aspire orchestration for local development
├── TindahanNatin.Server/    # ASP.NET Core API, EF Core migrations, static file hosting
├── tindahan_natin/          # Flutter app for web and mobile
├── aspire.config.json       # Points Aspire CLI and tooling at the AppHost
└── TindahanNatin.sln        # .NET solution for AppHost + server
```

## What Each Project Does

- `TindahanNatin.AppHost` starts the local stack for development. It provisions PostgreSQL, Redis, and MinIO, then launches the backend and a Flutter web runner.
- `TindahanNatin.Server` is the API. It contains the feature endpoints, EF Core data model and migrations, Auth0-backed authentication, and local static file hosting.
- `tindahan_natin` is the Flutter client. It can run as a web app through the AppHost or directly on Android, iOS, or another Flutter target.

## Prerequisites

- .NET SDK 10.0
- Flutter SDK compatible with Dart `^3.11.5`
- Docker Desktop or another local container runtime supported by Aspire
- Android Studio / Android SDK if you want to run the mobile app on Android
- Xcode if you want to run the mobile app on iOS from macOS

## Environment Variables

The Flutter app reads its runtime configuration from `--dart-define` values. The wrapper script at `tindahan_natin/scripts/run_flutter.sh` converts environment variables into those `--dart-define` flags for you.

### Core Variables

| Variable | Required | Used By | Purpose |
| --- | --- | --- | --- |
| `SERVER_HTTP` | Yes for most local runs | Flutter | Base URL for the backend API. The app falls back to `http://localhost:5000`, but you should set this explicitly whenever the server is not reachable there. |
| `AUTH0_DOMAIN` | Yes | Flutter | Auth0 tenant domain used by login. Example: `tindahannatin.jp.auth0.com`. |
| `AUTH0_CLIENT_ID` | Yes | Flutter | Auth0 application client ID for the mobile/web app. |
| `AUTH0_CLIENT_ID_WEB` | Yes | Landing | Auth0 client ID for the Landing Page (Regular Web App). |
| `AUTH0_CLIENT_SECRET_WEB` | Yes | Landing | Auth0 client secret for the Landing Page. |
| `AUTH0_SECRET` | Yes | Landing | A random 32+ character string for Auth.js session encryption. |
| `AUTH0_MANAGEMENT_CLIENT_ID` | Yes | Server | Auth0 Management API client ID for account deletion. |
| `AUTH0_MANAGEMENT_CLIENT_SECRET` | Yes | Server | Auth0 Management API client secret. |
| `AUTH0_AUDIENCE` | Yes | Flutter | Auth0 API audience. Example: `https://tindahannatin.com`. |
| `PUBLIC_WEB_APP_BASE_URL` | Recommended | Flutter | Public base URL used when building shareable store links, for example `https://example.com`. |

| `BANNER_AD_UNIT_ID` | No | Flutter | AdMob banner ad unit ID. |
| `INTERSTITIAL_AD_UNIT_ID` | No | Flutter | AdMob interstitial ad unit ID. |
| `NATIVE_AD_UNIT_ID` | No | Flutter | AdMob native ad unit ID. |

### Android-Specific Variable

| Variable | Required | Used By | Purpose |
| --- | --- | --- | --- |
| `AUTH0_SCHEME` | Recommended for Android | Android build | Callback URL scheme for the Auth0 Android integration. If omitted, the Gradle config falls back to `demo`. |

### Backend Configuration

The server already includes these defaults in `TindahanNatin.Server/appsettings.json`:

- `Auth0:Domain = tindahannatin.jp.auth0.com`
- `Auth0:Audience = https://tindahannatin.com`

When you run the backend through Aspire, PostgreSQL, Redis, MinIO, and CORS configuration are injected by the AppHost. For the Flutter client, you still need to provide the client-facing environment variables listed above.

## Run The Full Local Stack

From the repository root:

```bash
export SERVER_HTTP=http://localhost:5000
export AUTH0_DOMAIN=tindahannatin.jp.auth0.com
export AUTH0_CLIENT_ID=<your-auth0-client-id>
export AUTH0_AUDIENCE=https://tindahannatin.com
export PUBLIC_WEB_APP_BASE_URL=http://localhost:8000

dotnet run --project TindahanNatin.AppHost
```

What this does:

- starts PostgreSQL, Redis, and MinIO containers
- starts the ASP.NET Core API
- starts the Flutter web app through `tindahan_natin/scripts/run_flutter.sh web`

The AppHost config exposes the Flutter web app on port `8000`. The backend is started by Aspire and is consumed by the Flutter app through `SERVER_HTTP`.

## Run Only The Backend

If you want to work on the API by itself:

```bash
dotnet run --project TindahanNatin.Server
```

This path is useful for backend-only work, but it does not provision PostgreSQL, Redis, or MinIO for you. For normal end-to-end local development, prefer the AppHost.

## Run The Flutter App Manually

Change into the Flutter project first:

```bash
cd tindahan_natin
flutter pub get
```

### Web

```bash
export SERVER_HTTP=http://localhost:5000
export AUTH0_DOMAIN=tindahannatin.jp.auth0.com
export AUTH0_CLIENT_ID=<your-auth0-client-id>
export AUTH0_AUDIENCE=https://tindahannatin.com
export PUBLIC_WEB_APP_BASE_URL=http://localhost:8000

./scripts/run_flutter.sh web
```

### Android

```bash
export SERVER_HTTP=https://<reachable-api-url>
export AUTH0_DOMAIN=tindahannatin.jp.auth0.com
export AUTH0_CLIENT_ID=<your-auth0-client-id>
export AUTH0_AUDIENCE=https://tindahannatin.com
export PUBLIC_WEB_APP_BASE_URL=https://<reachable-web-url>
export AUTH0_SCHEME=<your-auth0-scheme>

./scripts/run_flutter.sh android
```

For Android devices and emulators, make sure `SERVER_HTTP` points to an API URL the device can actually reach. A browser-only `localhost` URL from your development machine usually will not work on a physical device, and often will not work on an emulator unless you use a platform-specific host alias or tunnel.

### iOS

```bash
export SERVER_HTTP=https://<reachable-api-url>
export AUTH0_DOMAIN=tindahannatin.jp.auth0.com
export AUTH0_CLIENT_ID=<your-auth0-client-id>
export AUTH0_AUDIENCE=https://tindahannatin.com
export PUBLIC_WEB_APP_BASE_URL=https://<reachable-web-url>

./scripts/run_flutter.sh ios
```

## Notes For Mobile Development

- The AppHost currently registers a Flutter web executable. Mobile app runs are expected to be started manually from `tindahan_natin`.
- If you use a remote tunnel for the API and web app, set `SERVER_HTTP` and `PUBLIC_WEB_APP_BASE_URL` to those public URLs before starting Flutter.
- The sample command used in local development looks like this:

```bash
flutter run \
  --dart-define=AUTH0_DOMAIN=tindahannatin.jp.auth0.com \
  --dart-define=AUTH0_CLIENT_ID=<your-auth0-client-id> \
  --dart-define=AUTH0_AUDIENCE=https://tindahannatin.com \
  --dart-define=SERVER_HTTP=https://<reachable-api-url> \
  --dart-define=PUBLIC_WEB_APP_BASE_URL=https://<reachable-web-url>
```

## Useful Directories In The Codebase

- `TindahanNatin.Server/Features/` contains the API endpoint groups.
- `TindahanNatin.Server/Data/` contains the EF Core `DbContext`.
- `TindahanNatin.Server/Migrations/` contains the database migrations.
- `tindahan_natin/lib/features/` contains feature UI and application logic.
- `tindahan_natin/lib/core/` contains shared app infrastructure like config and networking.
- `tindahan_natin/scripts/` contains helper scripts for local Flutter runs.

## Common Commands

```bash
# Start the full local stack
dotnet run --project TindahanNatin.AppHost

# Start only the API
dotnet run --project TindahanNatin.Server

# Fetch Flutter dependencies
cd tindahan_natin && flutter pub get

# Run Flutter tests
cd tindahan_natin && flutter test

# Analyze Flutter code
cd tindahan_natin && flutter analyze
```

## Production Deployment

The project is configured for deployment to **Google Cloud Run** using **Terraform** and **GitHub Actions**.

### Infrastructure
*   **API**: Google Cloud Run
*   **Container Registry**: Google Cloud Artifact Registry
*   **Object Storage**: Cloudflare R2 (S3-compatible)
*   **Database**: External PostgreSQL (e.g., Supabase, Neon)
*   **Cache**: External Redis (e.g., Upstash)

### CI/CD Pipeline
The deployment is automated via the `.github/workflows/deploy.yml` workflow, which:
1.  Builds the .NET container using the SDK's native container support.
2.  Pushes the image to Google Artifact Registry.
3.  Runs `terraform apply` to provision/update the infrastructure and deploy the new image.

### Manual Setup Required
See the `Manual Preparations Required` section in the [Deployment Plan](deploy-cloudrun.md) for details on GCP Project setup, Cloudflare configuration, and GitHub Secrets.