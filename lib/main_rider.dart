import 'package:byahero/screens/home_screen.dart';
import 'package:byahero/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'resources/app_config.dart';
// import 'main.dart';
import 'package:provider/provider.dart';
import './states/appstate.dart';
import './states/mapstate.dart';
import './screens/riders/ridersMap_screen.dart';





void main() {
  //create a variable for AppConfig
  var configuredApp = AppConfig(
    homePage: 1,
    appTitle: "Passengers App",
    buildFlavor: "Production",
    child: MyDriverApp(),
    accountType: 2,
  );
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AppState(),
        ),
        ChangeNotifierProvider.value(
          value: MapState(),
        ),
      ],
      child: configuredApp,
    ),
  );

  // return runApp(configuredApp);
}


class  MyDriverApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return _MyDriverApp(context);
  }
  _MyDriverApp(context) {
    
    MaterialApp buildMaterialRiderApp() {
      return MaterialApp(
        initialRoute: HomeScreen.id,
        theme: ThemeData(
          primaryColor: Colors.indigo[400],
          accentColor: Colors.blueAccent[800],
        ),
        routes: {
          // MapScreen.id: (context) => MapScreen(
          //       androidFusedLocation: true,
          // ),
          RiderMapScreen.id: (context) => RiderMapScreen(
                androidFusedLocation: true,
          ),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          // HomeScreen.id: (context) => HomeScreen(),
        },
      );
    }

    if (AppConfig.of(context).homePage == 1) {
      return buildMaterialRiderApp();
    }
  }
}
