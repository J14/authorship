import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:authorship/models/content.dart';

class ListContent extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/content";

  @override
  State<ListContent> createState() {
    return ListContentState();
  }
}

class ListContentState extends State<ListContent> {
  List contents;

  Future<String> getAllContents() async {
    var response = await http
        .get(Uri.encodeFull(widget.url), headers: {"Accept": "application/json"});

    setState(() {
      Map<String, dynamic> dataJson = json.decode(response.body);
      contents =
          dataJson['data'].map((content) => Content.fromJson(content)).toList();
    });

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choice Content"),
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
                      Navigator.pop(context, contents[index]);
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

    this.getAllContents();
  }
}
