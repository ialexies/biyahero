import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../controllers/helper_google_account.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appHeader(context, titleText: 'Settings', removeBackButton: true),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: RaisedButton(
                child: Text('Logout'),
                onPressed: (){
                 GoogleAccountHelper(appContext: context).logoutgoogle();
                },
              ),),
            ],
          )
        ],
      ),
    );
  }
}