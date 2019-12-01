import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text("Criar Localização"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/location');
                  },
                ),
                RaisedButton(
                  child: Text("Criar Conteúdo"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/content');
                  },
                ),
                RaisedButton(
                  child: Text("Criar Atividade"),
                  onPressed: () {
                    Navigator.pushNamed(context, '/activity');
                  },
                ),
              ],
            )
          ),
          RaisedButton(
            child: Text("Sair"),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.remove('token');
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      )
    );
  }
}