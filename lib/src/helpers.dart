import 'dart:convert';

enum ActionTypes { newChat, chatMessage, leaveChat }

encodeMessage(ActionTypes type, String from, String message) => json.encode({
  'type': type.toString(),
  'from': from,
  'data': message
});

decodeMessage(String message) {
  var decoded = json.decode(message);
  return {
    'type': getActionType(decoded['type']),
    'from': decoded['from'],
    'data': decoded['data'],
  };
}

ActionTypes getActionType(String type) {
  ActionTypes matchedAction;
  ActionTypes.values.forEach((action) {
    if (action.toString() == type) {
      matchedAction = action;
    }
  });
  return matchedAction;
}
