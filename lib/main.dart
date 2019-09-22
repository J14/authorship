import 'package:flutter/material.dart';
import 'package:authorship/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Autoria",
      home: LoginApp(),
    );
  }
}