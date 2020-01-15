import 'dart:async';
import 'dart:convert';

import 'package:authorship/models/course.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ListCourse extends StatefulWidget {

  final String url = "http://class-path-auth.herokuapp.com/my-courses/";

  @override
  State<StatefulWidget> createState() {
    return ListCourseState();
  }
}

class ListCourseState extends State<ListCourse> {
  List courses;
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = true;

    this._getAllCourses();
  }

  Future<String> _getAllCourses() async {
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
      setState(() {
        List data = json.decode(response.body);
        courses = data.map((course) => Course.fromJson(course)).toList();
        _loading = false;
      });
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Courses"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container(),
        ),
      ),
      body: ListView.builder(
        itemCount: courses == null ? 0 : courses.length,
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
                          courses[index].name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(courses[index]);
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