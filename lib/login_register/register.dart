import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sampleproject/services/register_services.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Register register = Register();

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Full Name'),
                    ),
                    TextFormField(
                      controller: userController,
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: TextButton(
              onPressed: () async {
                http.Response response = await register.register(nameController.text, userController.text, passController.text);
                print(jsonDecode(response.body));
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
