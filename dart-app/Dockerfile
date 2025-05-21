# Stage 1: Build the Dart app
FROM dart:3.5 AS build

WORKDIR /app

# Get dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy source files
COPY . .

# Compile AOT executable
RUN dart compile exe bin/main.dart -o bin/app_executable

# Stage 2: Minimal runtime image
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libstdc++6 \
    && rm -rf /var/lib/apt/lists/*

# Copy Dart runtime and libs from official Dart image
COPY --from=dart:3.5 /runtime/ /runtime/
ENV PATH="/runtime/bin:${PATH}"

WORKDIR /app

# Copy compiled executable
COPY --from=build /app/bin/app_executable /app/bin/app_executable

# Create a non-root user for security
RUN useradd -m dartuser && chown -R dartuser /app
USER dartuser

ENTRYPOINT ["/app/bin/app_executable"]
