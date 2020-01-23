import 'package:flutter/material.dart';

class TransactionState with ChangeNotifier{

  //**----Init Variables---**//
  String _currentTransaction;


  //**----Get Request---**//
  getCurrentTransaction()=>_currentTransaction;

  
  //**----Set Variables---**//
  @override
  void setCurrentTransaction({String transactionId}){
    _currentTransaction=transactionId;
    notifyListeners();
  }

}