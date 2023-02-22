import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:sampleproject/services/login_services.dart';
import 'package:sampleproject/login_register/dashboard.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Login login = Login();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                      controller: userController,
                      decoration: InputDecoration(hintText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field should not be empty';
                        }
                      },
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field should not be empty';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  http.Response response = await login.login(userController.text, passController.text);
                  if (jsonDecode(response.body)['name'] != '') {
                    print(jsonDecode(response.body)['name']);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Dashboard(username: jsonDecode(response.body)['name']);
                      },
                    ));
                  } else {
                    print('Username or Password is incorrect');
                  }
                }
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
                    'Login',
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
