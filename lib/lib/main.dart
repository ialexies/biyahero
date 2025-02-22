import 'package:byahero/resources/app_config.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';
import './screens/registration_screen.dart';
import 'package:provider/provider.dart';
import './states/appstate.dart';
import './states/mapstate.dart';

import 'package:byahero/screens/riders/ridersMap_screen.dart';

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

class MyPassengerApp extends StatelessWidget {
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

    if (AppConfig.of(context).homePage == 1) {
      return buildMaterialPassengerApp();
    }
  }
}


// class  MyDriverApp extends StatelessWidget {
 
//   @override
//   Widget build(BuildContext context) {
//     return _MyDriverApp(context);
//   }
//   _MyDriverApp(context) {
    
//     MaterialApp buildMaterialRiderApp() {
//       return MaterialApp(
//         initialRoute: HomeScreen.id,
//         theme: ThemeData(
//           primaryColor: Colors.red[400],
//           accentColor: Colors.blueAccent[800],
//         ),
//         routes: {
//           // MapScreen.id: (context) => MapScreen(
//           //       androidFusedLocation: true,
//           // ),
//           MapScreen.id: (context) => RiderMapScreen(
//                 androidFusedLocation: true,
//           ),
//           RegistrationScreen.id: (context) => RegistrationScreen(),
//           HomeScreen.id: (context) => HomeScreen(),
//           HomeScreen.id: (context) => HomeScreen(),
//         },
//       );
//     }

//     if (AppConfig.of(context).homePage == 1) {
//       return buildMaterialRiderApp();
//     }
//   }
// }

