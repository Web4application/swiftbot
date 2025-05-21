# Build the Docker image
docker build -t swiftbot .

# Run the Docker container
docker run -p 3000:3000 swiftbot
