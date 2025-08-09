class Attachment {
  final String name;
  final String mime;
  final String contentString;

  Attachment({
    required this.name,
    required this.mime,
    required this.contentString,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'mime': mime,
    'contentString': contentString,
  };
}

class ChatRequest {
  final String message;
  final String mode; // 'query' | 'chat'
  final String sessionId;
  final List<Attachment>? attachments;
  final bool reset;

  ChatRequest({
    required this.message,
    required this.mode,
    required this.sessionId,
    this.attachments,
    this.reset = false,
  });

  Map<String, dynamic> toJson() => {
    'message': message,
    'mode': mode,
    'sessionId': sessionId,
    'attachments': attachments?.map((a) => a.toJson()).toList(),
    'reset': reset,
  };
}
