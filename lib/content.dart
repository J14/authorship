import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ContentPage extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/content";

  @override
  State<ContentPage> createState() {
    return ContentPageState();
  }
}

class ContentPageState extends State<ContentPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<String> _save(Content content) async {
    var response = await http.post(Uri.encodeFull(widget.url),
        body: json.encode(content),
        headers: {"content-type": "application/json"});

    if (response.statusCode == 201) {
      Navigator.pop(context);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Content"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "title",
                  hintText: "Title of content",
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
                maxLines: 5,
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "description",
                  hintText: "Description of content",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Back"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text("Clear"),
                    onPressed: () {
                      titleController.clear();
                      descriptionController.clear();
                    },
                  ),
                  RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Content content = Content(
                            titleController.text, descriptionController.text);

                        _save(content);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class Content {
  String id;
  final String title;
  final String description;

  Content(this.title, this.description);

  Content.fromJson(Map<String, dynamic> dataJson)
      : this.id = dataJson['_id'],
        this.title = dataJson['title'],
        this.description = dataJson['description'];

  Map<String, String> toJson() =>
      {'title': this.title, 'description': this.description};
}
