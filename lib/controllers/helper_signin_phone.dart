import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:byahero/states/mapstate.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';
// import '../states/appstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn googlePhoneSignIn = GoogleSignIn();
final firestoreInstance = Firestore.instance;
final usersRef = Firestore.instance.collection('users');
// final groupNameRef = Firestore.instance.collection('groups');
// final groupUsersNameRef = Firestore.instance.collection('group_user');
// final usersGroupRef = Firestore.instance.collection('users').document("");


class GooglePhoneAccountHelper {
  GooglePhoneAccountHelper();
  // logoutgoogle() {
  //   print('signout');
  //   googlePhoneSignIn.signOut();
  // }

  // login() async {
  //   print('login');
  //   // print('$tester');
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('with internet');
  //       googlePhoneSignIn.signIn();
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //     // _showSnackBar();
  //   }
  // }

  // handleSignIn(GoogleSignInAccount account, context) async {
  //   final appState = Provider.of<AppState>(context);
  //   if (account != null) {
  //     // print('User signed in!: $account');
  //     await createUserInFirestore(context:context);
  //     appState.updateIsAuth(true);
  //   } else {
  //     appState.updateIsAuth(false);
  //     //  AppState().isAuth = false;
  //     //  AppState().updateIsAuth(false);

  //   }
  // }


createUserPhoneInFirestore({context, phoneNumber}) async {
  
}


  createUserInFirestore({context, phoneNumber}) async {
    // final appState = Provider.of<AppState>(context);
    // final mapState = Provider.of<MapState>(context);
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googlePhoneSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final additionalUserInfo = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationScreen(
                    userInfo: user,
                  )));

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": await additionalUserInfo[0],
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "groups":[],
        // "timestamp": AppState().timestamp,
        "contactNumber": await additionalUserInfo[1],
        "address": await additionalUserInfo[2],
        // "currentLat":mapState.initalPositionLat,
        // "currentLong":mapState.initalPositionLong,
      });

      // appState.updateIsAuth(true);
      // appState.saveGoogleAccount(user);
      Navigator.pushNamed(context, HomeScreen.id);
    } else {
      print(' already logged in and authenticated');
      // appState.updateIsAuth(true);
      // appState.saveGoogleAccount(user);

    }
  }
}
