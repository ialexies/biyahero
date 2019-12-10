import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../controllers/helper_google_account.dart';

   unAuthScreen(context){
    googleSignIn.onCurrentUserChanged.listen((account) {
      GoogleAccountHelper().handleSignIn(account,context);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    return    Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60),
            Center(
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                  
                    child: Container(
                      height: 70,
                      child: Image.asset('images/logo.png'),
                      // height: controller.value,
                    ),
                  ),
                  // Text(
                  //   'Xchange Gifts',
                  //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
              title: 'login with Google',
              colour: Theme.of(context).primaryColor,
              onPressed: () {
                // Navigator.pushNamed(context, LoginScreen.id);
                GoogleAccountHelper().login();
              },
            ),
          ],
        ),
      ),
    );

  }



 