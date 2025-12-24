#!/bin/bash

echo "🚀 Running in STG environment..."

flutter run \
  --dart-define=APP_ENV=stg \
  --dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true \
  "$@"
