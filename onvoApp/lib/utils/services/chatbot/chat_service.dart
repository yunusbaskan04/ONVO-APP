import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiKey;
  static const String baseUrl = 'https://bqayjf1u.rpcld.co/api/v1';
  static const String workspaceSlug = 'deneme';

  ChatService({required this.apiKey});

  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String mode, // "chat" veya "query"
    required String sessionId,
    bool reset = false,
    List<Map<String, dynamic>>? attachments,
  }) async {
    final url = Uri.parse('$baseUrl/workspace/$workspaceSlug/chat');

    final body = {
      'message': message,
      'mode': mode, // chat veya query olmalı
      'sessionId': sessionId,
      'reset': reset,
    };

    if (attachments != null && attachments.isNotEmpty) {
      body['attachments'] = attachments;
    }

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Hatası: ${response.statusCode}\n${response.body}');
    }
  }
}
