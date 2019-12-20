import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../states/appstate.dart';

//  final usersRef = Firestore.instance.collection('users');
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount user = googleSignIn.currentUser;

// print(currentuse);

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
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage(appState.getGoogleCurrentAccountPhoto()),
                      fit: BoxFit.cover),
                  borderRadius: new BorderRadius.all(Radius.circular(75)),
                  border: Border.all(color: Colors.grey[400], width: 5),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(appState.getGoogleCurrentAccountDisplayName(),
              style: kTextHeading1,
              ),
              // Text(appState.getGoogleCurrentAccountDisplayName()),
            ],
          ),
        ),
      ),
    );
  }
}
