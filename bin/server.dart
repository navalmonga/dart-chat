import 'dart:io';
import 'dart:convert';
import 'package:dart_chat/src/chat_session.dart';

main() async {
  var port = 9783;
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Server listening on port $port');
  var chatSession = ChatSession();
  await for (HttpRequest request in server) {
    // Handle requests
    // TODO: Only needed in local development. Will be removed in future
    request.response.headers.add('Access-Control-Allow-Origin', 'http://localhost:8080');
    switch (request.uri.path) {
      case '/signin':
        String payload = await request.transform(Utf8Decoder()).join();
        var username = Uri.splitQueryString(payload)['username'];

        if (username != null && username.isNotEmpty) {
          print("working");
          request.response
            ..write(username)
            ..close();
        } else {
          print("notworking");
          request.response
            ..statusCode = 400
            ..write('Invalid user name')
            ..close();
        }
        break;
      case '/ws':
        String username = request.uri.queryParameters['username'];
        chatSession.addChat(request, username);
        break;
      default:
    }
  }
}
