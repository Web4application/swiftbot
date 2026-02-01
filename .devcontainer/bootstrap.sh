#!/usr/bin/env bash
set -e

echo "🚀 Bootstrapping Codespace..."

################################
# Node
################################
if [ -f package.json ]; then
  echo "📦 Installing Node packages..."
  npm install
fi

################################
# Python
################################
echo "🐍 Setting Python venv..."
python3 -m venv venv || true
source venv/bin/activate
pip install --upgrade pip

if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

################################
# Swift check
################################
if command -v swift >/dev/null 2>&1; then
  echo "🧠 Building Swift project..."
  swift build || true
fi

################################
# Docker build
################################
if [ -f Dockerfile ]; then
  echo "🐳 Building Docker image..."
  docker build -t swiftbot . || true
fi

################################
# UI scaffold (optional)
################################
if [ ! -d liveblocks-ui ]; then
  echo "⚛️ Creating Liveblocks UI..."
  mkdir liveblocks-ui
  cd liveblocks-ui
  npx create-liveblocks-app@latest --init --framework react
  cd ..
fi

echo "✅ Codespace ready!"
