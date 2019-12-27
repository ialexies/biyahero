import 'package:flutter/material.dart';
import '../widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appHeader(context, titleText: 'Profile', removeBackButton: true),
      body: Text('Hello This is Profile'),
    );
  }
}