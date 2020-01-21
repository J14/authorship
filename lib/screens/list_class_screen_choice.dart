import 'dart:async';
import 'dart:convert';

import 'package:authorship/models/class.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ListClassChoice extends StatefulWidget {

  final String url = "http://class-path-auth.herokuapp.com/my-classes/";

  @override
  State<StatefulWidget> createState() {
    return ListClassChoiceState();
  }
}

class ListClassChoiceState extends State<ListClassChoice> {
  List classes;
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = true;

    this._getAllClasses();
  }

  Future<String> _getAllClasses() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(
      Uri.encodeFull(widget.url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token $token"
      }
    );

    String body = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      setState(() {
        List data = json.decode(body);
        classes = data.map((_class) => Class.fromJson(_class)).toList();
        _loading = false;
      });
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha uma turma"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container(),
        ),
      ),
      body: ListView.builder(
        itemCount: classes == null ? 0 : classes.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  InkWell(
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          classes[index].name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, classes[index]);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}