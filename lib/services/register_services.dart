import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register {
  Future<http.Response> register(String name, username, password) async {
    String url = 'http://192.168.0.137:3000/save';
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': name, 'username': username, 'password': password}),
    );
    return response;
  }
}
