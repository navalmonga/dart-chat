import 'dart:html';
import './router.dart';
import './views/chat_auth.dart';
import './views/chat_room.dart';

void main() {
  router
    ..register('/', (_) => ChatAuth())
    ..register('/chat-room', (params) => ChatRoom(params))
    ..go('/');
}
