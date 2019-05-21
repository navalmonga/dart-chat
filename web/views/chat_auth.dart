import 'dart:html';
import './view.dart';
import '../router.dart';

class ChatAuth implements View {
  ChatAuth(): _contents = DocumentFragment() {
    onEnter();
  }
  DocumentFragment _contents;
  DivElement chatSignInDiv;
  ParagraphElement validation;
  InputElement nameInput;
  ButtonElement submitButton;
  HttpRequest _response;

  @override
  void onEnter() {
    prepare();
    render();
  }
  @override
  void onExit() {
    nameInput.removeEventListener('input', _inputHandler);
    submitButton.removeEventListener('click', _clickHandler);

    router.go('/chat-room', params: {'username':_response.responseText});
  }
  @override
  void prepare() {
    _contents.innerHtml = '''
    <div id="chatSignIn">
      <h1 class="title">Dart Chat</h1>
      <div class="columns">
        <div class="column is-6">
          <div class="field">
            <label class="label">Please enter your name</label>
            <div class="control is-expanded has-icons-left">
              <input class="input is-medium" type="text" placeholder="Enter a name, then press enter" />
              <span class="icon is-medium is-left">
                <i class="fas fa-user"></i>
              </span>
            </div>
            <p class="help is-danger"></p>
          </div>
          <div class="field">
            <div class="control">
              <button class="button is-medium is-primary">
                Join chat!
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    ''';
    chatSignInDiv = _contents.querySelector('#chatSignIn');
    validation = chatSignInDiv.querySelector('p.help');
    nameInput = chatSignInDiv.querySelector('input[type="text"]');
    submitButton = chatSignInDiv.querySelector('button');

    _addEventListeners();
  }
  @override
  void render() {
    querySelector('#app')
      ..innerHtml = ''
      ..append(_contents);
  }
  void _addEventListeners() {
    nameInput.addEventListener('input', _inputHandler);
    submitButton.addEventListener('click', _clickHandler);
  }
  void _inputHandler(event) {
    // Run field validation
    if (nameInput.value.trim().isNotEmpty) {
      nameInput.classes
        ..removeWhere((className) => className == 'is-danger')
        ..add('is-success');
      validation.text = '';
    } else {
      nameInput.classes
        ..removeWhere((className) => className == 'is-success')
        ..add('is-danger');
    }
  }
  void _clickHandler(event) async {
    // Run field validation
    if (nameInput.value.trim().isEmpty) {
      nameInput.classes.add('is-danger');
      validation.text = 'Name is required.';
      return;
    }
    submitButton.disabled = true;
    // Submit name to backend
    try {
      _response = await HttpRequest.postFormData('http://localhost:9783/signin',
        {
          'username':nameInput.value,
        },
      );
      // Switch view
      onExit();
    } catch(e) {
      submitButton
        ..disabled = false
        ..text = 'Failed to join chat, try again.';
    }
  }

}
