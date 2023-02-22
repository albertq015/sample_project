import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sampleproject/login_register/dashboard.dart';
import 'package:sampleproject/services/update_credentials.dart';
import 'package:http/http.dart' as http;

class UpdateCredentialsPage extends StatefulWidget {
  int? userId;
  String? name;
  String? username;
  String? password;
  UpdateCredentialsPage({Key? key, this.name, this.password, this.username, this.userId}) : super(key: key);

  @override
  State<UpdateCredentialsPage> createState() => _UpdateCredentialsPageState();
}

class _UpdateCredentialsPageState extends State<UpdateCredentialsPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Update update = Update();

  @override
  void initState() {
    userController.text = widget.username!;
    passController.text = widget.password!;
    nameController.text = widget.name!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Credentials'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Name'),
                    ),
                    TextFormField(
                      controller: userController,
                      decoration: InputDecoration(hintText: 'Username'),
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(hintText: 'Password'),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    http.Response response =
                        await update.update(widget.userId!, widget.name!, nameController.text, userController.text, passController.text);
                    print(response.body);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(
                            name: jsonDecode(response.body)['Result']['name'],
                            username: jsonDecode(response.body)['Result']['username'],
                            password: jsonDecode(response.body)['Result']['password'],
                          ),
                        ));
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
