import 'package:flutter/material.dart';

import 'package:authorship/content.dart';
import 'package:authorship/activity.dart';


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
                    print("Criar Localização");
                  },
                ),
                RaisedButton(
                  child: Text("Criar Conteúdo"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContentPage())
                    );
                  },
                ),
                RaisedButton(
                  child: Text("Criar Atividade"),
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ActivityPage())
                    );
                  },
                ),
              ],
            )
          ),
          RaisedButton(
            child: Text("Sair"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }
}