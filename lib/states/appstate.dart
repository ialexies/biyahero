import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppState with ChangeNotifier {
  final DateTime timestamp = DateTime.now();
  bool isAuth = false;
  GoogleSignInAccount _googleCurrentAccount;

  setCounter(GoogleSignInAccount googleCurrentAccount) => _googleCurrentAccount = googleCurrentAccount;

  // Get Requests
  getGoogleCurrentAccount() => _googleCurrentAccount;
  getGoogleCurrentAccountID() => _googleCurrentAccount.id;
  getGoogleCurrentAccountDisplayName() => _googleCurrentAccount.displayName;
  

  void updateIsAuth(bool isAuthenticated) {
    isAuth = isAuthenticated;
    notifyListeners();
  }

  void saveGoogleAccount(GoogleSignInAccount callGoogleAccount) {
    _googleCurrentAccount = callGoogleAccount;
    notifyListeners();
  }
}
