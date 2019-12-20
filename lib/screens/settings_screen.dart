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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Center(
              child:
                RaisedButton.icon(
                  
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  icon: Icon(Icons.exit_to_app),
                  label: Text('Logout'),
                  onPressed: () {
                  GoogleAccountHelper().logoutgoogle();
                },
                )
              
              //  RaisedButton(
              
              //   child: Text('Logout'),
              //   onPressed: () {
              //     GoogleAccountHelper().logoutgoogle();
              //   },
              // ),
            )
          ],
        ),
      ),
    );
  }
}
