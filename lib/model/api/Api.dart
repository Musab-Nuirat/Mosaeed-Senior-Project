import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // static const String apiUrl = 'http://127.0.0.1:5000/search';
  static const String apiUrl = 'http://192.168.1.2:5000/search';

  static Future<String> getChatReply(String query) async {
    var url = Uri.parse(apiUrl);
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({'query': query});

    try {
      // Send the POST request
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final reply = json['document'];
        return reply;
      } else {
        throw Exception('Failed to load chat data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load chat data');
    }
  }
}

