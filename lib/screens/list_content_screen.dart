import 'package:authorship/pages/content_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:authorship/models/content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListContent extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/contents/";

  @override
  State<ListContent> createState() {
    return ListContentState();
  }
}

class ListContentState extends State<ListContent> {
  List contents;
  bool _loading;

  Future<String> getAllContents() async {
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

    setState(() {
      List data = json.decode(body);
      contents = data.map((content) => Content.fromJson(content)).toList();
      _loading = false;
    });

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContentPage()
            )
          ).then((value) {
            if (value != null) {
              setState(() {
                _loading = true;
                getAllContents();
              });
            }
          });
        },
      ),
      appBar: AppBar(
        title: Text("List Content"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container(),
        )
      ),
      body: ListView.builder(
        itemCount: contents == null ? 0 : contents.length,
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
                          contents[index].title,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(contents[index]);
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

  @override
  void initState() {
    super.initState();

    _loading = true;

    this.getAllContents();
  }
}
