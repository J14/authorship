import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:authorship/models/content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentPage extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/contents/";

  @override
  State<ContentPage> createState() {
    return ContentPageState();
  }
}

class ContentPageState extends State<ContentPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading;

  @override
  void initState() {
    super.initState();

    _loading = false;
  }

  Future<String> _save(Content content) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    var response = await http.post(
      Uri.encodeFull(widget.url),
      body: json.encode(content),
      headers: {
        "content-type": "application/json",
        "Authorization": "Token $token"
      }
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    }

    return "Successfully";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conteúdo"),
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
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "título",
                    hintText: "Informe um título",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0)
                      )
                    )
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Por favor, informe um título";
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
                    hintText: "Descrição do conteúdo",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0)
                      )
                    ),
                  ),
                  validator: (value) {
                    if (value.isEmpty) return "Por favor, informe uma descrição";
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Salvar"),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          Content content = Content(
                              titleController.text, descriptionController.text);

                          _save(content);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0)
                        )
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      child: Text("Limpar"),
                      onPressed: () {
                        titleController.clear();
                        descriptionController.clear();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0)
                        )
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    RaisedButton(
                      child: Text("Voltar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0)
                        )
                      ),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
