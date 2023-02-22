import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login {
  Future<http.Response> login(username, password) async {
    String url = 'http://192.168.0.137:3000/get_user/';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'username': username, 'password': password}),
    );
    return response;
  }
}
