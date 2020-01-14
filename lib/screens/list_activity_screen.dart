import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:authorship/models/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListActivity extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/activities/";

  @override
  State<ListActivity> createState() {
    return ListActivityState();
  }
}

class ListActivityState extends State<ListActivity> {
  List activities;
  bool _loading;

  Future<String> getAllActivities() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(
      Uri.encodeFull(widget.url),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token $token"
      }
    );

    setState(() {
      List data = json.decode(response.body);
      activities = data.map((activity) => Activity.fromJson(activity)).toList();
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
          Navigator.pushNamed(context, "/activity");
        },
      ),
      appBar: AppBar(
        title: Text("List Activity"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container(),
        )
      ),
      body: ListView.builder(
        itemCount: activities == null ? 0 : activities.length,
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
                          activities[index].title,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      print(activities[index]);
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

    this.getAllActivities();
  }
}
