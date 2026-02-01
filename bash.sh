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
