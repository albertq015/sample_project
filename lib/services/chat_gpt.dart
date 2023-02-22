import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAI {
  var api = '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';
  // var api = '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';

  Future<String> chatGPT(String prompt) async {
    var url = Uri.https('api.openai.com', '/v1/completions');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $api'},
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'temperature': 0,
          'max_tokens': 2000,
          'top_p': 1,
          'frequency_penalty': 0.0,
          'presence_penalty': 0.0
        }));
    //List<CompletionApiResult> result = (await res) as List<CompletionApiResult>;
    //print(jsonDecode(response.body));
    Map<String, dynamic> newResponse = await jsonDecode(response.body);
    print(newResponse);
    return newResponse['choices'][0]['text'];
  }
}
