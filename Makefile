.PHONY: help dev stg prod clean

help:
	@echo "Flutter Run Commands:"
	@echo "  make dev        - Run app in DEV environment"
	@echo "  make stg        - Run app in STG environment"
	@echo "  make prod       - Run app in PROD environment"
	@echo "  make clean      - Clean build files"

dev:
	@echo "🚀 Running in DEV environment..."
	flutter run \
		--dart-define=APP_ENV=dev \
		--dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
		--dart-define=ENABLE_LOGGING=true

stg:
	@echo "🚀 Running in STG environment..."
	flutter run \
		--dart-define=APP_ENV=stg \
		--dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
		--dart-define=ENABLE_LOGGING=true

prod:
	@echo "🚀 Running in PROD environment..."
	flutter run \
		--dart-define=APP_ENV=prod \
		--dart-define=API_BASE_URL=https://api.yourdomain.com \
		--dart-define=ENABLE_LOGGING=false

clean:
	@echo "🧹 Cleaning build files..."
	flutter clean
	cd ios && rm -rf Pods Podfile.lock && pod install
