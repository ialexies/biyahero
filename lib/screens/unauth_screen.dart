

import 'package:byahero/controllers/helper_signin_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:byahero/constants.dart';
import 'package:byahero/controllers/helper_design.dart';
import 'package:byahero/screens/test_unauth_phone.dart';
import 'package:byahero/controllers/helper_google_account.dart';
import 'package:byahero/states/appstate.dart';
import 'package:byahero/screens/home_screen.dart';
// import 'package:fluttershare/controllers/helper_google_account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
// import 'package:fluttershare/screens/home_screen.dart';
import '../components/rounded_button.dart';
import '../controllers/helper_google_account.dart';
import 'home_screen.dart';
import '../states/appstate.dart';
import 'package:byahero/controllers/helper_signin_phone.dart';



unAuthScreen(context) {

  final _loginFormKey = GlobalKey<FormState>();
//

  googleSignIn.onCurrentUserChanged.listen((account) {
    GoogleAccountHelper().handleSignIn(account, context);
  }, onError: (err) {
    print('Error signing in: $err');
  });



  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
          0.4,
          0.9,
        ],
            colors: [
          Colors.cyan,
          Colors.greenAccent[200],
        ])),
    child: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            bottom: -10,
            height: 100,
            child: Image.asset('images/home_back_buildings.png'),
          ),
          Positioned(
            top: 30,
            child: Center(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 130,
                  child: Image.asset('images/byeherologo.png'),
                ),
              ),
            ),
          ),
          Positioned(
            top: 170,
            height: 260,
            child: Container(
              width: appsScreenWidth(context) - 90,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _loginFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter your email';
                              }
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              hintText: 'Enter Email',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter your email';
                              }
                            },
                            decoration: kTextFieldDecoration.copyWith(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              hintText: 'Enter Password',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RoundedButton(
                            title: 'Login',
                            colour: Colors.cyan,
                            onPressed: () {},
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.5),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: Offset(10, 10))
                ],
              ),
            ),
          ),
          Positioned(
            top: 370,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 60),

                SizedBox(height: 20),
                // RoundedButton(
                //   title: 'login with Google',
                //   colour: Theme.of(context).primaryColor,
                //   onPressed: () {
                //     // Navigator.pushNamed(context, LoginScreen.id);
                //     GoogleAccountHelper().login();
                //   },
                // ),
                SignInButton(
                  Buttons.Google,
                  // mini: true,
                  text: "Sign in with Google",
                  onPressed: () {
                    GoogleAccountHelper().login(context);
                  },
                ),
                SignInButton(
                  Buttons.Google,
                  // mini: true,
                  text: "Sign in Phone",
                  onPressed: () async{
                    // This will call the dialog box together its functions of phone login in firebase
                   await phoneAccountLoginHelper(context);
                  },
                ),
                // SignInButton(
                //   Buttons.Facebook,
                //   // mini: true,
                //   text: "Sign in with Google",
                //   onPressed: () {GoogleAccountHelper().login();},
                // )
                // FlatButton(
                //   onPressed: null,
                //   child: Image.asset('images/logo.png'),
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
