import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:authorship/models/location.dart';

class LocationPage extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/locations/";

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
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = false;
  }

  Future<String> _save(Location location) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.post(Uri.encodeFull(widget.url),
        body: json.encode(location),
        headers: {
          "Content-type": "application/json",
          "Authorization": "Token $token"
        });

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localização"),
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
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    labelText: "nome",
                    hintText: "Nome da localização",
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Por favor, informe um nome";
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
                      labelText: "descrição",
                      hintText: "Descrição da localização",
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                  validator: (value) {
                    if (value.isEmpty)
                      return "Por favor, informe uma descrição";
                    return null;
                  },
                ),
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Salvar"),
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              position != null) {
                            setState(() {
                              _loading = true;
                            });
                            Location location = Location(
                              name: nameController.text,
                              description: descriptionController.text,
                              latitude: position.latitude,
                              longitude: position.longitude,
                            );

                            _save(location);
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                      RaisedButton(
                        child: Text("Limpar"),
                        onPressed: () {
                          nameController.clear();
                          descriptionController.clear();
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                      ),
                      RaisedButton(
                        child: Text("Voltar"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        color: Colors.blue,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                  ),
                  Container(
                    height: 150.0,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("longitude: "),
                                position == null
                                    ? Text("")
                                    : Text(position.longitude.toString())
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text("latitude: "),
                                position == null
                                    ? Text("")
                                    : Text(position.latitude.toString())
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 150,
                              height: 40.0,
                              child: RaisedButton(
                                child: Text("Capturar localização"),
                                onPressed: () async {
                                  var pos = await Geolocator()
                                      .getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.best);

                                  setState(() {
                                    this.position = pos;
                                  });
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 120,
                              height: 40.0,
                              child: RaisedButton(
                                child: Text("Limpar"),
                                onPressed: () {
                                  setState(() {
                                    position = null;
                                  });
                                },
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
