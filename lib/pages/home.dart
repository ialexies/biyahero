import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/activity_feed.dart';
import 'package:fluttershare/pages/map_route.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/search.dart';
import 'package:fluttershare/pages/timeline.dart';
import 'package:fluttershare/pages/upload.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final usersRef = Firestore.instance.collection('users');
final DateTime timestamp = DateTime.now();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  bool internetStatus = false;

  //generate unique key for widget
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    pageController = PageController(
      // initialPage: 0,
    );
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      // print('User signed in!: $account');
      await createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final DocumentSnapshot doc = await usersRef.document(user.id).get();
    // print(user);
    // print(user.displayName);
    // print(user.email);
    // print(user.photoUrl);

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final additionalUserInfo = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount(userInfo: user,)));

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": additionalUserInfo[0],
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp,
        "contactNumber": additionalUserInfo[1],
        "address":additionalUserInfo[2],

      });
    }
  }

  login() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        googleSignIn.signIn();
      }
    } on SocketException catch (_) {
      // print('not connected');
      _showSnackBar();
    }

    
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  //changing the page in pageview
  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  //show snackbar
  _showSnackBar() {
    // print("Show Snackbar here !");
    final snackBar = new SnackBar(
        content: new Text("Please connect to the Internet"),
        duration: new Duration(seconds: 3),
        backgroundColor: Colors.red,
        action: new SnackBarAction(label: 'Ok', onPressed: (){
          print('Please connect to the Internet');
        }),
    );
    //How to display Snackbar ?
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Scaffold buildAuthScreen() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: logout,
        child: Icon(Icons.exit_to_app),
      ),
      body: PageView(
        children: <Widget>[
          Maproute(),
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged(pageIndex),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
       key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   onPressed:  _showSnackBar,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'ByaHero',
              style: TextStyle(
                fontFamily: "Signatra",
                fontSize: 90.0,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              // onTap: login,
              // onTap: interntStats()? print("dfdf") : ,
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }

void interntStats()async{
  bool stats = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // googleSignIn.signIn();
        // stats=true;
        //  login();
        setState(() {
          internetStatus = true;
        });
      }
    } on SocketException catch (_) {
      // print('not connected');
      // stats=false;
      // return ;
      // return SnackBar();
      setState(() {
        internetStatus = false;
      });
    }
}



}


