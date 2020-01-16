import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  final String url = "http://class-path-auth.herokuapp.com/my-account/";

  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();

    _loadAccount();
  }

  Future<String> _loadAccount() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(Uri.encodeFull(widget.url), headers: {
      "Accept": "application/json",
      "Authorization": "Token $token"
    });

    String body = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Map data = json.decode(body);
      int teacherId = data['profile']['teacher_id'];

      prefs.setInt("teacher_id", teacherId);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "App Author",
            style: TextStyle(
              color: Colors.blue
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: GridView.count(
      padding: const EdgeInsets.symmetric(
        vertical: 70.0, horizontal: 5.0
      ),
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.map,
                  size: 40.0,
                ),
                Text(
                  "Localização",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/listLocation");
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.bookmark,
                  size: 40.0,
                ),
                Text(
                  "Conteúdo",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/listContent");
            },
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.format_list_numbered,
                    size: 40.0,
                  ),
                  Text(
                    "Atividade",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/listActivity");
              },
            )),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    size: 40.0
                  ),
                  Text(
                    "Sair",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.pushReplacementNamed(context, '/');
              },
            )),
      ],
    ));
  }
}
