import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final apiKey = Platform.environment['DART_API_KEY'] ?? 'supersecretdartkey';

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print("Dart app listening on port 8080");

  await for (HttpRequest request in server) {
    if (request.method == 'POST' && request.uri.path == '/analyze') {
      final requestApiKey = request.headers.value('x-api-key');
      if (requestApiKey != apiKey) {
        request.response
          ..statusCode = HttpStatus.unauthorized
          ..write(jsonEncode({'error': 'Unauthorized'}));
        await request.response.close();
        continue;
      }

      try {
        final content = await utf8.decoder.bind(request).join();
        final data = jsonDecode(content);
        final script = data['script'] as String? ?? '';

        final suspiciousKeywords = ['eval', 'exec', 'Function', 'require'];
        final issues = suspiciousKeywords.where((kw) => script.contains(kw)).toList();

        final result = {
          'length': script.length,
          'suspicious_keywords': issues,
          'message': 'Dart script analyzed successfully.'
        };

        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(result));
      } catch (e, stack) {
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write(jsonEncode({'error': e.toString()}));
        stderr.writeln('Error handling request: $e\n$stack');
      }
      await request.response.close();
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found');
      await request.response.close();
    }
  }
}
