import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:authorship/models/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListLocationChoice extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/locations/";

  @override
  State<ListLocationChoice> createState() {
    return ListLocationChoiceState();
  }
}


class ListLocationChoiceState extends State<ListLocationChoice> {
  List locations;
  bool _loading;

  Future<String> getAllLocations() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    int teacherId = prefs.getInt("teacher_id");

    var response = await http.get(
      Uri.encodeFull("${widget.url}?teacher_id=$teacherId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Token $token"
      }
    );

    String body = utf8.decode(response.bodyBytes);

    setState(() {
      List data = json.decode(body);
      locations = data.map((location) => Location.fromJson(location)).toList();
      _loading = false;
    });

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choice Location"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: _loading ? LinearProgressIndicator() : Container()
        )
      ),
      body: ListView.builder(
        itemCount: locations == null ? 0 : locations.length,
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
                          locations[index].name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context, locations[index]);
                    },
                  ),
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

    this.getAllLocations();
  }
}
