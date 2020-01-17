import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:authorship/models/content.dart';


class DetailContent extends StatefulWidget {
  final String url = "http://class-path-content.herokuapp.com/contents";
  final Content content;

  DetailContent({Key key, @required this.content}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailContentState();
  }
}

class DetailContentState extends State<DetailContent> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Content content;
  bool _loading;

  @override
  void initState() {
    super.initState();

    content = widget.content;

    titleController.text = this.content.title;
    descriptionController.text = this.content.description;

    _loading = false;
  }

  Future<String> _update(Content content) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.patch(
      Uri.encodeFull("${widget.url}/${content.id}/"),
      body: json.encode(content),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Token $token"
      }
    );

    if (response.statusCode == 200) {
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
                    )
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

                          this.content.title = titleController.text;
                          this.content.description = descriptionController.text;

                          _update(content);
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}