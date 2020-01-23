// import 'dart:js';

import 'package:byahero/screens/home_screen.dart';
import 'package:byahero/states/appstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper_google_account.dart';



 phoneAccountLoginHelper(context){

   
  // final BuildContext appContext;
  // phoneAccountLoginHelper(this.appContext);

  final appState = Provider.of<AppState>(context);
  String phoneNo;
  String smsCode;
  String verificationId;

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      // Navigator.of(context).pushReplacementNamed('/homepage');
      print('signing in using phone $verificationId');
      appState.updateIsAuth(true);
      Navigator.of(context).pushReplacementNamed(HomeScreen.id);
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter sms code'),
            content: TextField(
              onChanged: (value) {
                smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              new FlatButton(
                child: Text('Done'),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      appState.updateIsAuth(true);

                      Navigator.of(context).pop();
                      // Navigator.of(context).pushReplacementNamed('/homepage');
                      Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                    } else {
                      Navigator.of(context).pop();

                      signIn();
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) async{
      print('phone number verified');
      // appState.updateIsAuth(true);
      // Navigator.of(context).pushReplacementNamed(HomeScreen.id);


       


      FirebaseAuth.instance.currentUser().then((user) {
        if (user != null) {

          appState.updateIsAuth(true);
          Navigator.of(context).pushReplacementNamed(HomeScreen.id);
          appState.savefirebaseUser(user);

          GoogleAccountHelper().checkPhoneNumberifHasProfile(context,user.phoneNumber);
        }
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('Problem in phone verification -${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verificationFailed,
    );
  }



  // Future<void> loginwithPhone(context) async {
    TextEditingController phoneNumval = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login with Phone Number'),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Form(
                  autovalidate: true,
                  child: TextFormField(
                    controller: phoneNumval,
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      String patttern = r'(^(09)\d{9}$)';
                      // String patttern = r'(^(09|\+639)\d{9}$)'; // accept also +63

                      RegExp regExp = new RegExp(patttern);

                      if (val.length == 0) {
                        return 'Please enter mobile number';
                      } else if (val.length > 11) {
                        return 'Phone Number is too long';
                      } else if (val.length < 11) {
                        return 'Phone Number is too short';
                      } else if (!regExp.hasMatch(val)) {
                        return 'Invalid Format, ex: 09455000123';
                      }
// return null;

                      // if (val.trim().length<11){
                      //   return 'Phone Number is too Short';
                      // }
                      // else if (val.trim().length>11){
                      //   return 'Phone Number is too long';
                      // }
                    },
                    decoration: InputDecoration(
                      hintText: '09190001234',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    onChanged: (value) {
                      phoneNo = "+63$value";
                      print(phoneNo);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: verifyPhone,
                  child: Text('Login'),
                  elevation: 7,
                  color: Theme.of(context).primaryColor,
                ),
                Divider()
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  // }



}