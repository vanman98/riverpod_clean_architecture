#!/bin/bash

echo "🚀 Running in DEV environment..."

flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true \
  "$@"
