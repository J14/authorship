import 'dart:convert';
import 'dart:async';

import 'package:authorship/pages/activity_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:authorship/models/activity.dart';
import 'package:authorship/pages/execute_activity.dart';

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
  bool _delete;

  Future<String> getAllActivities() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.get(Uri.encodeFull(widget.url), headers: {
      "Accept": "application/json",
      "Authorization": "Token $token"
    });

    String body = utf8.decode(response.bodyBytes);

    setState(() {
      List data = json.decode(body);
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
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ActivityPage()))
              .then((value) {
            if (value != null) {
              setState(() {
                _loading = true;
                getAllActivities();
              });
            }
          });
        },
      ),
      appBar: AppBar(
          title: Text("Atividades"),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 1.0),
            child: _loading ? LinearProgressIndicator() : Container(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              color: _delete ? Colors.red : Colors.white,
              onPressed: () {
                setState(() {
                  _delete = !_delete;
                });
              },
            )
          ],
      ),
      body: ListView.builder(
        itemCount: activities == null ? 0 : activities.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  child: _delete
                    ? _listWithDelete(activities[index])
                    : _listWithoutDelete(activities[index])
                ),
              ],
            ),
          ));
        },
      ),
    );
  }

  _listWithDelete(activity) {
    return ListTile(
      title: Text(
        activity.title,
        style: TextStyle(fontSize: 20.0),
      ),
      leading: Ink(
        child: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            String token = prefs.getString("token");

            setState(() {
              _loading = true;
            });
            var response = await http.delete(
              Uri.encodeFull(
                "http://class-path-content.herokuapp.com/activities/${activity.id}/"
              ),
              headers: {
                "Authorization": "Token $token"
              }
            );

            if (response.statusCode == 204) {
              getAllActivities();
            }
          },
          color: Colors.red,
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExecuteActivity(activity: activity)));
      },
    );
  }

  _listWithoutDelete(activity) {
    return ListTile(
      title: Text(
        activity.title,
        style: TextStyle(fontSize: 20.0),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExecuteActivity(activity: activity)));
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _loading = true;
    _delete = false;

    this.getAllActivities();
  }
}
