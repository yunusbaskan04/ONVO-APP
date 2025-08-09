class ChatResponse {
  final String id;
  final String? textResponse;
  final String? error;

  ChatResponse({required this.id, this.textResponse, this.error});

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
    id: json['id'] ?? 'unknown',
    textResponse: json['textResponse']?.toString(), // null olabilir
    error: json['error'],
  );
}
