import 'package:flutter/material.dart';

import 'package:authorship/pages/activity_page.dart';
import 'package:authorship/pages/content_page.dart';
import 'package:authorship/pages/location_page.dart';
import 'package:authorship/pages/login_page.dart';
import 'package:authorship/pages/menu_page.dart';

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