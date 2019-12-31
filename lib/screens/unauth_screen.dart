import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttershare/constants.dart';
import 'package:fluttershare/controllers/helper_design.dart';
import 'package:fluttershare/screens/test_unauth_phone.dart';
import '../components/rounded_button.dart';
import '../controllers/helper_google_account.dart';

unAuthScreen(context) {
  String phoneNo;
  String smsCode;
  String verificationId;

  signIn() {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/homepage');
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

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
      print('phone number verified');
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

  Future<void> loginwithPhone(context) async {
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
  }

  googleSignIn.onCurrentUserChanged.listen((account) {
    GoogleAccountHelper().handleSignIn(account, context);
  }, onError: (err) {
    print('Error signing in: $err');
  });

  final _loginFormKey = GlobalKey<FormState>();

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
                    GoogleAccountHelper().login();
                  },
                ),
                SignInButton(
                  Buttons.Google,
                  // mini: true,
                  text: "Sign in Phone",
                  onPressed: () {
                    loginwithPhone(context);
                    // print('fdfdf');
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
