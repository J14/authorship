import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LocationPage extends StatefulWidget {
  final String url = "https://pibic-project.herokuapp.com/location";

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
    var response = await http.post(
      Uri.encodeFull(widget.url),
      body: json.encode(location),
      headers: {
        "Content-type": "application/json"
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
                        nameController.text,
                        descriptionController.text,
                        [position.longitude, position.latitude]
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


class Location {
  String id;
  final String name;
  final String description;
  final List coord; // [longitude, latitude]

  Location(this.name, this.description, this.coord);

  Map<String, dynamic> toJson() =>
    {
      "name": this.name,
      "description": this.description,
      "coord": this.coord
    };

  Location.fromJson(Map<String, dynamic> dataJson)
    : this.id = dataJson['_id'],
      this.name = dataJson['name'],
      this.description = dataJson['description'],
      this.coord = dataJson['coord'];
}