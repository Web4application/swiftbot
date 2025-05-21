# Use a lightweight Node base image
FROM node:18-alpine

WORKDIR /app

# Install dependencies first for caching
COPY package*.json ./
RUN npm ci --production

# Copy app source code
COPY . .

# Expose port your Node server listens on (adjust if needed)
EXPOSE 3000

# Start the Node app
CMD ["node", "server.js"]
