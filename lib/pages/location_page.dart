import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:authorship/models/location.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocationPage extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/location/";

  @override
  State<LocationPage> createState() {
    return LocationPageState();
  }
}

class LocationPageState extends State<LocationPage> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Position position;

  Future<String> _save(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.post(
      Uri.encodeFull(widget.url),
      body: json.encode(location),
      headers: {
        "Content-type": "application/json",
        "Authenticate": "Token $token"
      }
    );

    if (response.statusCode == 201) {
      Navigator.pop(context);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autofocus: true,
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "name",
                  hintText: "Name of Location",
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
                  hintText: "Description of Location",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value.isEmpty) return "Please enter some text";
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Text("Capture location"),
                  onPressed: () async {
                    var pos = await Geolocator().getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high
                    );

                    setState(() {
                      this.position = pos;
                    });
                  },
                ),
                RaisedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_formKey.currentState.validate() && position != null) {
                      Location location = Location(
                        name: nameController.text,
                        description: descriptionController.text,
                        latitude: position.latitude,
                        longitude: position.longitude,
                      );

                      _save(location);
                    }
                  },
                ),
                RaisedButton(
                  child: Text("Back"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("longitude: "),
                      position == null ? Text("") : Text(position.longitude.toString())
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("latitude: "),
                      position == null ? Text("") : Text(position.latitude.toString())
                    ],
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
