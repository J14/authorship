import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:authorship/models/location.dart';

class ListLocation extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/location";

  @override
  State<ListLocation> createState() {
    return ListLocationState();
  }
}


class ListLocationState extends State<ListLocation> {
  List locations;

  Future<String> getAllLocations() async {
    var response = await http.get(
      Uri.encodeFull(widget.url),
      headers: {
        "Accept": "application/json"
      }
    );

    setState(() {
      Map<String, dynamic> dataJson = json.decode(response.body);
      locations = dataJson['data'].map((location) => Location.fromJson(location)).toList();
    });

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choice Location"),
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

    this.getAllLocations();
  }
}
