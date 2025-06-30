git add .
git commit -m "Added files from phone"
git push origin main

npx @sentry/wizard@latest -i nextjs --saas --org web4app --project swiftbot
npm install @sentry/nextjs --save

npx create-liveblocks-app@latest --init --framework react
