import 'dart:io';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:byahero/states/mapstate.dart';
import 'package:byahero/states/appstate.dart';
import 'package:byahero/states/appstate.dart';
// import 'package:fluttershare/states/appstate.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../screens/home_screen.dart';
import '../screens/registration_screen.dart';
import '../states/appstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final firestoreInstance = Firestore.instance;
final usersRef = Firestore.instance.collection('users');
final groupNameRef = Firestore.instance.collection('groups');
final groupUsersNameRef = Firestore.instance.collection('group_user');
final usersGroupRef = Firestore.instance.collection('users').document("");

// final _firestore = Firestore.instance;
// final usersRef = Firestore.instance.collection('users');


class GoogleAccountHelper {
  final BuildContext appContext;
  GoogleAccountHelper({this.appContext});
  FirebaseUser _currentFirebaseUser;

  // GoogleAccountHelper();
  logoutgoogle(context) {
    final appState = Provider.of<AppState>(context);
    print('signout');
    
    googleSignIn.signOut();
    FirebaseAuth.instance.signOut();
    appState.updateIsAuth(false);
    // print(AppState().getAuthVal());
    appState.deleteUsersInfo();
    Navigator.of(appContext).pushReplacementNamed(HomeScreen.id);
    // print(AppState().getAuthVal());
  }

  login() async {
    print('login');
    // print('$tester');
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('with internet');
        googleSignIn.signIn();

        loginUserInFirebase();
    
      }
    } on SocketException catch (_) {
      print('not connected');
      // _showSnackBar();
    }
  }

  // Add the current user signed in in the firebase list of auth user
  loginUserInFirebase() async{
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user = (await FirebaseAuth.instance.signInWithCredential(credential));
      // _currentFirebaseUser = user.uid;
      print("signed in " + user.displayName);
  }

  handleSignIn(GoogleSignInAccount account, context) async {
    final appState = Provider.of<AppState>(context);
    if (account != null) {
      print('User signed in!: $account');
      await createUserInFirestore(context:context);
      appState.updateIsAuth(true);
      loginUserInFirebase();
    } else {
      appState.updateIsAuth(false);
      //  AppState().isAuth = false;
      //  AppState().updateIsAuth(false);

    }
    // final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  }
  handleFirebaseSignIn(FirebaseUser account, context) async {
    final appState = Provider.of<AppState>(context);
    if (account != null) {
      print('User signed in!: $account');
      await createUserInFirestore(context:context);
      appState.updateIsAuth(true);
      loginUserInFirebase();
    } else {
      appState.updateIsAuth(false);
      //  AppState().isAuth = false;
      //  AppState().updateIsAuth(false);

    }
    // final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  }

  createUserInFirestore({context, phoneNumber}) async {
    final appState = Provider.of<AppState>(context);
    final mapState = Provider.of<MapState>(context);
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.document(user.id).get();
    final firebaseUserID = await FirebaseAuth.instance.currentUser().then((user){return user.uid.toString();});

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
        "uid":firebaseUserID,
        "id": user.id,
        "username": await additionalUserInfo[0],
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "groups":[],
        "timestamp": AppState().timestamp,
        "contactNumber": await additionalUserInfo[1],
        "address": await additionalUserInfo[2],
        "currentLat":mapState.initalPositionLat,
        "currentLong":mapState.initalPositionLong,
      });

      appState.updateIsAuth(true);
      appState.saveGoogleAccount(user);
      Navigator.pushNamed(context, HomeScreen.id);
    } else {
      print(' already logged in and authenticated');
      appState.updateIsAuth(true);
      appState.saveGoogleAccount(user);

    }
  }

  checkPhoneNumberifHasProfile(context,phoneNumber) async{
    final appState = Provider.of<AppState>(context);
    //  final Query doc = await usersRef.where("contactNumber","==","$phoneNumber");
      FirebaseUser firebaseuser = await appState.getFirebaseCurrentAccount();
      print(  'your phone number is -- ${firebaseuser.phoneNumber} ');

    // FirebaseUser firebaseuser = await appState.getFirebaseCurrentAccount();
    // print('-------------current $firebaseuser');
    // final QuerySnapshot doc =  await  usersRef.where("contactNumber", isEqualTo: firebaseuser.phoneNumber).getDocuments();
    // print(doc.toString());
  }

}
