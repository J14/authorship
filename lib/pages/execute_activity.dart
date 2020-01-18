import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:authorship/models/activity.dart';
import 'package:authorship/models/location.dart';
import 'package:authorship/models/content.dart';

class ExecuteActivity extends StatefulWidget {
  final String url = "https://class-path-location.herokuapp.com/distance/";
  final Activity activity;
  final Location location;
  final Content content;

  ExecuteActivity({Key key, @required this.activity})
      : this.location = activity.location,
        this.content = activity.content,
        super(key: key);

  @override
  State<ExecuteActivity> createState() {
    return ExecuteActivityState();
  }
}

class ExecuteActivityState extends State<ExecuteActivity> {
  final contentController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> _distance(Position position) async {
    List origin = [position.latitude, position.longitude];
    List destination = [widget.location.latitude, widget.location.longitude];

    Map data = {'origin': origin, 'destination': destination, 'threshold': 10};

    var response = await http.post(Uri.encodeFull(widget.url),
        body: json.encode(data), headers: {'Content-type': 'application/json'});

    String body = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      Map dataJson = json.decode(body);

      if (dataJson['threshold']) {
        contentController.text = widget.content.description;
      } else {
        contentController.text = "Localização incorreta";
      }

      scaffoldKey.currentState
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("${dataJson['distance']}"),
          ),
        );
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste da atividade"),
      ),
      key: scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            child: TextFormField(
              enabled: false,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Atividade",
                border: OutlineInputBorder(),
              ),
              initialValue: widget.activity.description,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            child: Center(
              child: ButtonTheme(
                minWidth: 200.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text("Verificar localização"),
                  onPressed: () async {
                    Position position = await Geolocator().getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);

                    _distance(position);
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: TextFormField(
              enabled: false,
              maxLines: 5,
              controller: contentController,
              decoration: InputDecoration(
                labelText: "Conteúdo",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
