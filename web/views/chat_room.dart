import 'dart:html';
import './view.dart';
import '../router.dart';
import 'package:dart_chat/src/chat_subject.dart';
import 'package:dart_chat/src/helpers.dart';

class ChatRoom implements View {
  ChatRoom(this.params): _contents = DocumentFragment(),
                         _subject = ChatSubject(params['username'])
  {
    onEnter();
  }

  final ChatSubject _subject;
  Map params;
  DocumentFragment _contents;
  DivElement chatBox;
  DivElement chatLog;
  InputElement messageField;
  ButtonElement sendButton;
  ButtonElement leaveButton;

  @override
  void onEnter() {
    prepare();
    render();
  }
  @override
  void onExit() {
    _removeEventListeners();

    router.go('/');
  }
  @override
  void prepare() {
    _contents.innerHtml = '''
      <div id="chatRoom">
      <div class="columns">
          <div class="column is-two-thirds-mobile is-two-thirds-desktop">
            <h1 class="title">Room</h1>
          </div>
          <div class="column has-text-right">
            <button
              id="chatLeaveButton"
              class="button is-warning">Leave Chat</button>
          </div>
        </div>
        <div class="tile is-ancestor">
          <div class="tile is-8 is-vertical is-parent">
            <div class="tile is-child box">
              <div id="chatLog"></div>
            </div>
            <div class="tile is-child">
              <div class="field has-addons">
                <div class="control is-expanded has-icons-left">
                  <input id="chatRoomMessage" class="input is-medium" type="text" placeholder="Enter your message" />
                  <span class="icon is-medium is-left">
                    <i class="fas fa-keyboard"></i>
                  </span>
                </div>
                <div class="control">
                  <button id="chatRoomSendButton" class="button is-medium is-primary">
                    Send&nbsp;&nbsp;
                    <span class="icon is-medium">
                      <i class="fas fa-paper-plane"></i>
                    </span>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      ''';

      chatBox = _contents.querySelector('#chatRoom');
      chatLog = chatBox.querySelector('#chatLog');
      messageField = chatBox.querySelector('#chatRoomMessage');
      sendButton = chatBox.querySelector('#chatRoomSendButton');
      leaveButton = chatBox.querySelector('#chatLeaveButton');

      _addEventListeners();
  }

  @override
  void render() {
    querySelector('#app')
      ..innerHtml = ''
      ..append(_contents);
  }

  void _addEventListeners() {
    sendButton.disabled = true;
    messageField.addEventListener('input', _messageFieldInputHandler);
    sendButton.addEventListener('click', _sendButtonHandler);
    leaveButton.addEventListener('click', _leaveButtonHandler);
    _subject.socket.onMessage.listen(_subjectMessageHandler);
  }
  void _removeEventListeners() {
    messageField.removeEventListener('input', _messageFieldInputHandler);
    sendButton.removeEventListener('click', _sendButtonHandler);
    leaveButton.removeEventListener('click', _leaveButtonHandler);
  }
  void _leaveButtonHandler(e) => onExit();
  void _subjectMessageHandler(event) {
     var decoded = decodeMessage(event.data);
     var from = decoded['from'];
     var message = decoded['data'];
     var result;

     if (from == null) {
      result = '''
        <div class="tags">
          <p class="tags is-light is-normal">$message</p>
        </div>
        ''';
     } else {
      result = '''
        <div class="tags has-addons">
          <span class="tag ${from == 'You'? 'is-primary': 'is-dark'}">$from said:</span>
          <span class="tag is-light">$message</span>
        </div>
        ''';
     }
     chatLog.appendHtml(result);
  }
  void _messageFieldInputHandler(event) {
    sendButton.disabled = messageField.value.isEmpty;
  }
  void _sendButtonHandler(event) {
    _subject.send(encodeMessage(
      ActionTypes.chatMessage,
      params['username'],
      messageField.value,
    ));

    messageField
      ..value = ''
      ..focus();
  }
}
