import 'dart:html';
import './helpers.dart';
class ChatSubject {
  ChatSubject(String username)
    : socket = WebSocket('ws://localhost:9783/ws?username=$username') {
      _initListeners();
    }
  final WebSocket socket;
  _initListeners() {
    socket.onOpen.listen((event) {
      print('Socket is open');
      send(encodeMessage(ActionTypes.newChat, null, null));
    });
    socket.onError.listen((event) {
      print('Socket error. ${event}');
    });
    socket.onClose.listen((event) {
      print('Socket is closed');
    });
  }
  send(String data) => socket.send(data);
  close() => socket.close();
}
