import 'package:authorship/activity.dart';
import 'package:authorship/content.dart';
import 'package:authorship/location.dart';
import 'package:flutter/material.dart';
import 'package:authorship/login.dart';
import 'package:authorship/menu.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Autoria",
      initialRoute: '/',
      routes: {
        '/': (context) => LoginApp(),
        '/menu': (context) => Menu(),
        '/location': (context) => LocationPage(),
        '/content': (context) => ContentPage(),
        '/activity': (context) => ActivityPage(),
      }
    );
  }
}