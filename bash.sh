git add .
git commit -m "Added files from phone"
git push origin main

npx @sentry/wizard@latest -i nextjs --saas --org web4app --project swiftbot
npm install @sentry/nextjs --save

npx create-liveblocks-app@latest --init --framework react

# Build the Docker image
docker build -t swiftbot .

# Run the Docker container
docker run -p 8000:8000 swiftbot

git branch -m codespace-bookish-rotary-phone-4jq5vwwj59rqcjrpv main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a

# Generate
swift run swiftbot generate "Suggest 5 startup ideas in fintech"

# Summarize a PDF
swift run swiftbot summarize ./whitepaper.pdf

# Interactive Chat
swift run swiftbot chat

# 1️⃣ Set your API key
export GOOGLE_API_KEY="your_google_generative_ai_key"

# 2️⃣ Run summarizer
swift run summarize ./docs/manifesto.md

# 3️⃣ Or specify output + model
swift run summarize ./whitepaper.pdf --model "gemini-1.5-flash" --output summary.py
git clone https://github.com/Web4application/script_analyzer_bot.git
cd script_analyzer_bot
# Set up virtual environment and install requirements
pip install -r requirements.txt

#!/usr/bin/env bash
set -e

echo "🚀 Starting full Swiftbot AI Codespace setup..."

################################
# Load AI keys from Codespaces
################################
echo "🔐 Loading AI keys..."
export GOOGLE_API_KEY=${GOOGLE_API_KEY}
export OPENAI_API_KEY=${OPENAI_API_KEY}
echo "✅ Secrets loaded!"

################################
# Node setup
################################
if [ -f package.json ]; then
  echo "📦 Installing Node packages..."
  npm install
fi

################################
# Python setup
################################
echo "🐍 Setting up Python virtual environment..."
python3 -m venv venv || true
source venv/bin/activate
pip install --upgrade pip
if [ -f requirements.txt ]; then
  pip install -r requirements.txt
fi

################################
# Swift setup
################################
if command -v swift >/dev/null 2>&1; then
  echo "🧠 Building Swiftbot..."
  swift build || true
fi

################################
# Docker setup
################################
if [ -f docker-compose.yml ]; then
  echo "🐳 Building Docker stack..."
  docker compose build || true
fi

################################
# Frontend scaffold
################################
if [ ! -d liveblocks-ui ]; then
  echo "⚛️ Creating Liveblocks UI..."
  mkdir liveblocks-ui
  cd liveblocks-ui
  npx create-liveblocks-app@latest --init --framework react
  cd ..
fi

################################
# Start backend & frontend
################################
echo "🏁 Starting Swiftbot backend..."
if command -v swift >/dev/null 2>&1; then
  swift run swiftbot chat &
fi

echo "🏁 Starting frontend..."
if [ -f package.json ]; then
  npm run dev &
fi

echo "🏁 Starting Docker stack..."
if [ -f docker-compose.yml ]; then
  docker compose up -d
fi

echo "✅ Full Codespace setup complete!"
echo "Ports 3000 (frontend) & 8000 (backend) should be forwarded automatically."
sha:6d3686c30d4cda9e1db2f528134cafe0b42de430
