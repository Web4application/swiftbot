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
