import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:authorship/models/content.dart';
import 'package:authorship/models/location.dart';
import 'package:authorship/models/activity.dart';
import 'package:authorship/models/course.dart';

import 'package:authorship/screens/list_content_screen_choice.dart';
import 'package:authorship/screens/list_location_screen_choice.dart';
import 'package:authorship/screens/list_course_screen_choice.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ActivityPage extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/activities/";

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
  Course course;
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = false;
  }

  Future<String> _save(Activity activity) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var response = await http.post(Uri.encodeFull(widget.url),
        body: json.encode(activity),
        headers: {
          'Content-type': 'application/json',
          'Authorization': "Token $token"
        });

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
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      labelText: "title",
                      hintText: "Title of activity",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
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
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  validator: (value) {
                    if (value.isEmpty) return "Please enter some text";
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0)
                  )
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Location:"),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ButtonTheme(
                              minWidth: 250.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () async {
                                  var location = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListLocationChoice()));

                                  setState(() {
                                    this.location = location;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue)),
                                color: location == null
                                    ? Colors.white
                                    : Colors.blue,
                                textColor: location == null
                                    ? Colors.blue
                                    : Colors.white,
                                child: location == null
                                    ? Text("Choice")
                                    : Text(location.name),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Content:"),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ButtonTheme(
                              minWidth: 250.0,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () async {
                                  var content = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListContentChoice()));

                                  setState(() {
                                    this.content = content;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue)),
                                color: content == null
                                    ? Colors.white
                                    : Colors.blue,
                                textColor: content == null
                                    ? Colors.blue
                                    : Colors.white,
                                child: content == null
                                    ? Text("Choice")
                                    : Text(content.title),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Course:"),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: ButtonTheme(
                              minWidth: 250,
                              height: 40.0,
                              child: RaisedButton(
                                onPressed: () async {
                                  var course = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListCourseChoice()));

                                  setState(() {
                                    this.course = course;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.blue)),
                                color:
                                    course == null ? Colors.white : Colors.blue,
                                textColor:
                                    course == null ? Colors.blue : Colors.white,
                                child: course == null
                                    ? Text("Choice")
                                    : Text(course.name),
                              ),
                            ),
                          )
                        ],
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
                      child: Text("Save"),
                      onPressed: () {
                        if (_formKey.currentState.validate() &&
                            this.content != null &&
                            this.location != null &&
                            this.course != null) {
                          setState(() {
                            _loading = true;
                          });
                          Activity activity = Activity(
                              title: titleController.text,
                              description: descriptionController.text,
                              location: this.location,
                              content: this.content,
                              course: this.course);

                          _save(activity);
                        }
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    ),
                    RaisedButton(
                      child: Text("Clear"),
                      onPressed: () {
                        titleController.clear();
                        descriptionController.clear();
                        setState(() {
                          content = null;
                          location = null;
                          course = null;
                        });
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    ),
                    RaisedButton(
                      child: Text("Back"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
