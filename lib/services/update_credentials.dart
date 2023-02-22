import 'dart:convert';

import 'package:http/http.dart' as http;

class Update {
  Future<http.Response> update(int id, String name, newName, username, password) async {
    String url = 'http://192.168.0.137:3000/update/$id';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'name': newName, 'username': username, 'password': password}),
    );
    return response;
  }
}
