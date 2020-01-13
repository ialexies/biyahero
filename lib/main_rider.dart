	import 'package:flutter/material.dart';
	import 'resources/app_config.dart';
	import 'main.dart';
	void main(){
	  
	  //create a variable for AppConfig
	  var configuredApp = AppConfig(
      homePage: 2,
	    appTitle: "Drivers app",
	    buildFlavor: "Production",
	    child: MyApp(),
	  );
	  return runApp(configuredApp);
}