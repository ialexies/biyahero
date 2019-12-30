import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class unAuthPhoneReg extends StatefulWidget {
  @override
  _unAuthPhoneRegState createState() => _unAuthPhoneRegState();
}

class _unAuthPhoneRegState extends State<unAuthPhoneReg> {
  String phoneNo;
  String smsCode;
  String verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhoneAuth'),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: 'Enter Phone Number'),
                onChanged: (value) {
                  this.phoneNo = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('verify'),
                elevation: 7,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

  
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value){
        print('Signed In');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user){
      print('phone number verified');
    };

    final PhoneVerificationFailed verificationFailed =(AuthException exception){
      print('Problem in phone verification -${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verificationFailed,

    );
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: Text('Enter sms code'),
          content: TextField(
            onChanged: (value){
              this.smsCode = value; 
            },
          ),
          contentPadding: EdgeInsets.all(10),
          actions: <Widget>[
            new FlatButton(
              child: Text('Done'),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  if (user!=null){
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/homepage');
                  }
                  else{
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
  signIn(){
    // FirebaseAuth.instance.signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode, ).then(user){
    //   Navigatr.of(context).pushReplacementNamed('/homepage');
    // }.catchError((e){
    //   print(e);
    // });

    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth.instance.signInWithCredential(credential).then((user){
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print(e);
    });
  }
}
