#!/usr/bin/env bash
set -e

echo "🚀 Starting all services..."

# Load AI keys
export GOOGLE_API_KEY=${GOOGLE_API_KEY}
export OPENAI_API_KEY=${OPENAI_API_KEY}

# Start Docker services
if [ -f docker-compose.yml ]; then
  echo "🐳 Starting Docker stack..."
  docker compose up -d
fi

# Start Swiftbot backend
if command -v swift >/dev/null 2>&1; then
  echo "🏁 Starting Swiftbot backend..."
  swift run swiftbot chat &
fi

# Start frontend
if [ -f package.json ]; then
  echo "🏁 Starting frontend..."
  npm run dev &
fi

echo "✅ All services running!"
