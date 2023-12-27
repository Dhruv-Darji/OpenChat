import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class GeminiService {

  Future<String> generateContent(String prompt) async { 
    final apiKey = 'AIzaSyDS9wIBRXjD-OiRmnDPTyAlcFkWu73QWNQ';
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';
    final body = convert.jsonEncode({
      'contents': [
        {'parts': [
          {
            'text': prompt
          }
        ]}
      ],
      'generationConfig': {
        'temperature': 0.9,
        'topK': 1,
        'topP': 1,
        'maxOutputTokens': 20000,
        'stopSequences': []
      },
    });
    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/json'
      }
    );
    if(response.statusCode==200){
      final data = convert.jsonDecode(response.body);
      print('This is the data: ${data['candidates'][0]['content']['parts'][0]['text']}');
      return data['candidates'][0]['content']['parts'][0]['text'];
    }else{
      print(response.body);
      throw Exception('Failed to generate content:${response.body}');
    }
  }
}