#!/bin/bash

echo "🚀 Running in PROD environment..."

flutter run \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false \
  "$@"
