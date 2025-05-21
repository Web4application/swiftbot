import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  final app = Router();

  app.post('/analyze', (Request request) async {
    final payload = await request.readAsString();
    // Simulate analysis: return length of received payload
    final length = payload.length;
    final response = {'length': length, 'message': 'Dart script analyzed successfully.'};
    return Response.ok(response.toString(), headers: {'content-type': 'application/json'});
  });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, '0.0.0.0', port);

  print('Dart server listening on port ${server.port}');
}
