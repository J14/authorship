import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "App Author",
            style: TextStyle(
              color: Colors.blue
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: GridView.count(
      padding: const EdgeInsets.symmetric(
        vertical: 70.0, horizontal: 5.0
      ),
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.map,
                  size: 40.0,
                ),
                Text(
                  "Localização",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/listLocation");
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: RaisedButton(
            textColor: Colors.white,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.bookmark,
                  size: 40.0,
                ),
                Text(
                  "Conteúdo",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/listContent");
            },
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.format_list_numbered,
                    size: 40.0,
                  ),
                  Text(
                    "Atividade",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/listActivity");
              },
            )),
        Container(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    size: 40.0
                  ),
                  Text(
                    "Sair",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ],
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                Navigator.pushReplacementNamed(context, '/');
              },
            )),
      ],
    ));
  }
}
