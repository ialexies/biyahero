import 'package:byahero/states/appstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: appHeader(context, titleText: 'Profile', removeBackButton: true),
      body: Column(
        children: <Widget>[
          Text(appState.getFirebaseCurrentAccount().toString(), ),
          Text(appState.getUserProfile().toString(), ),
          
        ],
      )
    );
  }
}