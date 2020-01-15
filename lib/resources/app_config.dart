
	import 'package:flutter/material.dart';
	import 'package:meta/meta.dart';
	class AppConfig extends InheritedWidget {
    final int homePage;
	  final String appTitle;
	  final String buildFlavor;
	  final Widget child;
    final int accountType;

  
 





	  AppConfig({
      @required this.homePage,
	    @required this.appTitle, 
	    @required this.buildFlavor,
	    @required this.child,
      @required this.accountType,
	    });
  
    AppConfigType(){
      return accountType;
    }
  
	  //static of function so that we can access appconfig anywhere
	  static AppConfig of(BuildContext context){
	    return context.dependOnInheritedWidgetOfExactType();
	  }
	  @override
	  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}