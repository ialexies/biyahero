	import 'package:flutter/material.dart';
	import 'resources/app_config.dart';
	import 'main.dart';
	void main(){
	  
	  //create a variable for AppConfig
	  var configuredApp = AppConfig(
      homePage: 1,
	    appTitle: "Passengers App",
	    buildFlavor: "Production",
	    child: MyApp(),
	  );
	  return runApp(configuredApp);
}