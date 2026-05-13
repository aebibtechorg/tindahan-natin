#!/bin/bash
# Wrapper to run `flutter run` with injected env variables turned into --dart-define flags.
# Usage: ./run_flutter.sh <platform> [extra flutter args]
set -euo pipefail

PLATFORM=${1:-web}
shift || true

# Build dart-define args from environment variables that start with "DART_DEFINE_" or known keys.
# Known keys: SERVER_HTTP, AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_AUDIENCE
DART_DEFINES=()
if [ -n "${SERVER_HTTP-}" ]; then
  DART_DEFINES+=("--dart-define=SERVER_HTTP=${SERVER_HTTP}")
fi
if [ -n "${AUTH0_DOMAIN-}" ]; then
  DART_DEFINES+=("--dart-define=AUTH0_DOMAIN=${AUTH0_DOMAIN}")
fi
if [ -n "${AUTH0_CLIENT_ID-}" ]; then
  DART_DEFINES+=("--dart-define=AUTH0_CLIENT_ID=${AUTH0_CLIENT_ID}")
fi
if [ -n "${AUTH0_AUDIENCE-}" ]; then
  DART_DEFINES+=("--dart-define=AUTH0_AUDIENCE=${AUTH0_AUDIENCE}")
fi

# Allow additional arbitrary env-to-dart-define via DART_DEFINE_<NAME>=value
for kv in $(env | grep -E '^DART_DEFINE_' || true); do
  name=$(echo "$kv" | sed -E 's/=.*//' )
  value=$(echo "$kv" | sed -E 's/^[^=]*=//')
  short=${name#DART_DEFINE_}
  DART_DEFINES+=("--dart-define=${short}=${value}")
done

case "$PLATFORM" in
  web)
    # Use web-server so we can control hostname/port. Let Aspire provide external endpoint.
    exec flutter run -d web-server --web-hostname 0.0.0.0 --web-port 0 "${DART_DEFINES[@]}" "$@"
    ;;
  android)
    # For Android, assume a connected device / emulator is available. Pass dart defines.
    exec flutter run "${DART_DEFINES[@]}" "$@"
    ;;
  ios)
    exec flutter run -d ios "${DART_DEFINES[@]}" "$@"
    ;;
  *)
    echo "Unknown platform: $PLATFORM" >&2
    exit 2
    ;;
esac
