import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // check if user is logged in
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByaHero',
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primaryColor: Colors.purple.withGreen(20),
        accentColor: Colors.teal,
      ),
    );
  }
}
