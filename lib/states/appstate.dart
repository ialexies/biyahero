import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppState with ChangeNotifier {
  

  //**----Variable Users---**//
  bool isAuth = false;
  GoogleSignInAccount _googleCurrentAccount;
  FirebaseUser _firebaseUser;
  dynamic finalUser;

  //**----Variable Assorted---**//
  final DateTime timestamp = DateTime.now();
  double _regPriceKm;
  double _minimumPrice;




  // Get Requests
  setCounter(GoogleSignInAccount googleCurrentAccount) => _googleCurrentAccount = googleCurrentAccount;
  getGoogleCurrentAccount() => _googleCurrentAccount;
  getGoogleCurrentAccountID() => _googleCurrentAccount.id;
  getGoogleCurrentAccountDisplayName() => _googleCurrentAccount.displayName;
  FirebaseUser getFirebaseCurrentAccount()=>_firebaseUser;  //getfirebase account
  getregPriceKm() => _regPriceKm;
  getminimumPrice() => _minimumPrice;
  


  void updateIsAuth(bool isAuthenticated) {
    isAuth = isAuthenticated;
    notifyListeners();
  }

  getAuthVal(){
    return  isAuth;
  }

  //delete Users Info
  void deleteUsersInfo(){
    _googleCurrentAccount = null;
    _firebaseUser = null;
    finalUser = null;
    notifyListeners();
  }

  //save google account in state
  void saveGoogleAccount(GoogleSignInAccount callGoogleAccount) {
    _googleCurrentAccount = callGoogleAccount;
    notifyListeners();
  }

  //Save Firebase user account in state
  void savefirebaseUser(FirebaseUser firebaseUser){
    _firebaseUser = firebaseUser;
    notifyListeners();
  }

  void getFirebaseUser(){

  }

}
