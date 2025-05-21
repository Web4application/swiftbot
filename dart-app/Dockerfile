FROM dart:3.5 AS build

WORKDIR /app

COPY pubspec.* ./
RUN dart pub get

COPY . .

RUN dart compile exe bin/main.dart -o bin/app_executable

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libstdc++6 ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=dart:3.5 /runtime/ /runtime/
ENV PATH="/runtime/bin:${PATH}"

WORKDIR /app

COPY --from=build /app/bin/app_executable /app/bin/app_executable

RUN useradd -m dartuser && chown -R dartuser /app
USER dartuser

ENV DART_API_KEY=supersecretdartkey

EXPOSE 8080

ENTRYPOINT ["/app/bin/app_executable"]
