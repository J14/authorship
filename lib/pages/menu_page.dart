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

    var response = await http.get(
      Uri.encodeFull(widget.url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token $token"
      }
    );

    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      int teacherId = data['profile']['teacher_id'];

      prefs.setInt("teacher_id", teacherId);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text("Criar Localização"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/location');
                  },
                ),
                RaisedButton(
                  child: Text("Criar Conteúdo"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/content');
                  },
                ),
                RaisedButton(
                  child: Text("Criar Atividade"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity');
                  },
                ),
              ],
            )
          ),
          RaisedButton(
            child: Text("Sair"),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      )
    );
  }
}