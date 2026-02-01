#!/usr/bin/env bash
set -e

echo "🚀 Bootstrapping Swiftbot AI Codespace..."

# Load AI keys
export GOOGLE_API_KEY=${GOOGLE_API_KEY}
export OPENAI_API_KEY=${OPENAI_API_KEY}
echo "🔐 AI keys loaded!"

# Node dependencies
if [ -f package.json ]; then
  echo "📦 Installing Node packages..."
  npm install
fi

# Python dependencies
echo "🐍 Setting up Python virtual environment..."
python3 -m venv venv || true
source venv/bin/activate
pip install --upgrade pip
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

# Swift build
if command -v swift >/dev/null 2>&1; then
  echo "🧠 Building Swiftbot..."
  swift build || true
fi

# Docker build
if [ -f docker-compose.yml ]; then
  echo "🐳 Building Docker stack..."
  docker compose build || true
fi

# Frontend scaffold if missing
if [ ! -d liveblocks-ui ]; then
  echo "⚛️ Creating Liveblocks UI..."
  mkdir liveblocks-ui
  cd liveblocks-ui
  npx create-liveblocks-app@latest --init --framework react
  cd ..
fi

echo "✅ Bootstrap complete!"
