import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:authorship/content.dart';
import 'package:authorship/location.dart';

class ActivityPage extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/activity";

  @override
  State<ActivityPage> createState() {
    return ActivityPageState();
  }
}

class ActivityPageState extends State<ActivityPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Content content;
  Location location;

  Future<String> _save(Activity activity) async {
    var response = await http.post(Uri.encodeFull(widget.url),
        body: json.encode(activity),
        headers: {'Content-type': 'application/json'});

    if (response.statusCode == 201) {
      Navigator.pop(context);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "title",
                  hintText: "Title of activity",
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
                    hintText: "Description of activity",
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Location:"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        var location = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListLocation()));

                        setState(() {
                          this.location = location;
                        });
                      },
                      child: location == null
                          ? Text("Choice")
                          : Text(location.name),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Content:"),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: RaisedButton(
                      onPressed: () async {
                        var content = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListContent()));

                        setState(() {
                          this.content = content;
                        });
                      },
                      child: content == null
                          ? Text("Choice")
                          : Text(content.title),
                    ),
                  ),
                ],
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
                      setState(() {
                        content = null;
                        location = null;
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          this.content != null &&
                          this.location != null) {
                        Activity activity = Activity(
                          titleController.text,
                          descriptionController.text,
                          this.location,
                          this.content
                        );

                        _save(activity);
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

class Activity {
  final String title;
  final String description;
  final Location location;
  final Content content;

  Activity(this.title, this.description, this.location, this.content);

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'location': location.id,
        'content': content.id
      };
}
