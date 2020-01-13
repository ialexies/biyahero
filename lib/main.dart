import 'package:byahero/resources/app_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/registration_screen.dart';
import 'package:provider/provider.dart';
import './states/appstate.dart';
import './states/mapstate.dart';
import 'package:byahero/screens/map_screeen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   return runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider.value(
//           value: AppState(),
//         ),
//         ChangeNotifierProvider.value(
//           value: MapState(),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePageOption(context);
  }

  HomePageOption(context) {
    MaterialApp buildMaterialPassengerApp() {
      return MaterialApp(
        initialRoute: HomeScreen.id,
        theme: ThemeData(
          primaryColor: Colors.yellowAccent[400],
          accentColor: Colors.green[800],
        ),
        routes: {
          MapScreen.id: (context) => MapScreen(
                androidFusedLocation: true,
              ),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
      );
    }

    MaterialApp buildMaterialRiderApp() {
      return MaterialApp(
        initialRoute: HomeScreen.id,
        theme: ThemeData(
          primaryColor: Colors.yellowAccent[400],
          accentColor: Colors.green[800],
        ),
        routes: {
          MapScreen.id: (context) => MapScreen(
                androidFusedLocation: true,
              ),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
        },
      );
    }

    if (AppConfig.of(context).homePage == 1) {
      return buildMaterialPassengerApp();
    }
  }
}

class MyDriverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.of(context).appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('This is drivers app'),
    );
  }
}
