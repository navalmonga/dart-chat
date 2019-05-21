import 'dart:io';
import 'dart:convert';
import 'package:dart_chat/src/helpers.dart';

class Chat {
  Chat({this.session, this.socket, this.name});
  HttpSession session;
  WebSocket socket;
  String name;
}
class ChatSession {
  final List<Chat> _chats = [];

  addChat(HttpRequest request, String username) async {
    WebSocket ws = await WebSocketTransformer.upgrade(request);
    Chat chat = Chat (
      session: request.session,
      socket: ws,
      name: username,
    );
    chat.socket.listen(
      (data) => _handleMessage(chat, data),
      onError: (err) => print('Error with socket ${err.message}'),
      onDone: () => _removeChat(chat),
    );
    _chats.add(chat);
    print('[ADDED CHAT]');
  }
  _handleMessage(Chat chat, String data) {
    print('[INCOMING MESSAGE]');

    Map<String, dynamic> decoded = json.decode(data);
    var actionType = getActionType(decoded['type']);
    var message = decoded['data'];

    switch(actionType) {
      case ActionTypes.newChat:
        chat.socket.add(encodeMessage(
          ActionTypes.newChat,
          null,
          'Welcome to the chat ${chat.name}.'
        ));
        _notifyChat(
          ActionTypes.newChat,
          chat,
          '${chat.name} has joined the chat.'
        );
        break;
      case ActionTypes.chatMessage:
        chat.socket.add(encodeMessage(
          ActionTypes.chatMessage,
          'You',
          message,
        ));
        _notifyChat(ActionTypes.chatMessage, chat, message);
        break;
      case ActionTypes.leaveChat:
        chat.socket.close();
        break;
      default:
        break;
    }
  }
  _notifyChat(ActionTypes actionType, Chat exclude, [String message]) {
    var from = actionType == ActionTypes.newChat ||
      actionType == ActionTypes.leaveChat? null: exclude.name;
    _chats
      .where((chat) => chat.name != exclude.name)
      .toList()
      .forEach((chat) => chat.socket.add(encodeMessage(
        actionType,
        from,
        message,
      )));
  }
  _removeChat(Chat chat) {
    print('[REMOVED CHAT]: ${chat.name}');
    _chats.removeWhere((c) => c.name == chat.name);
    _notifyChat(ActionTypes.leaveChat, chat, '${chat.name} has left the chat.');
  }
}
