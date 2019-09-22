import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:authorship/menu.dart';

class LoginApp extends StatefulWidget {
  final String loginUrl = "https://pibic-project.herokuapp.com/login";

  @override
  LoginAppState createState() => LoginAppState();
}

class LoginAppState extends State<LoginApp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<String> _login(User user) async {
    var response = await http.post(
      Uri.encodeFull(widget.loginUrl),
      body: json.encode(user),
      headers: {
        "content-type": "application/json",
      }
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Menu())
      );
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "username",
                  hintText: "Enter your username",
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  hintText: "Enter your password",
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  User user = User(usernameController.text, passwordController.text);

                  _login(user);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class User {
  final String username;
  final String password;

  User(this.username, this.password);

  Map<String, String> toJson() =>
    {
      'username': username,
      'password': password,
    };
}
