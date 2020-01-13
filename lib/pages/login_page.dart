import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:authorship/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApp extends StatefulWidget {
  final String loginUrl = "http://class-path-auth.herokuapp.com/login/";

  @override
  LoginAppState createState() => LoginAppState();
}

class LoginAppState extends State<LoginApp> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = false;
  }

  Future<String> _login(User user) async {
    var response = await http.post(Uri.encodeFull(widget.loginUrl),
        body: json.encode(user),
        headers: {
          "content-type": "application/json",
        });

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", data['token']);

      Navigator.pushReplacementNamed(context, '/menu');
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
            _loading ? CircularProgressIndicator() : _submit()
          ],
        ),
      ),
    );
  }

  Widget _submit() {
    return RaisedButton(
      child: Text("Submit"),
      onPressed: () {
        if(_formKey.currentState.validate()) {
          setState(() {
            _loading = true;
          });

          User user = User(usernameController.text, passwordController.text);

          _login(user);
        }
      },
    );
  }
}
