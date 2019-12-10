import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import './screens/group_join_screen.dart';
// import './screens/group_page_screen.dart';
// import './screens/group_create_screen.dart';
import './screens/home_screen.dart';
import './screens/registration_screen.dart';
import 'package:provider/provider.dart';
import './states/appstate.dart';
import './states/mapstate.dart';
import 'package:fluttershare/screens/map_screeen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AppState(),),
      ChangeNotifierProvider.value(value: MapState(),),
  ],
  child: MyApp(),));
}


class MyApp extends StatelessWidget {
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: HomeScreen.id,
      theme: ThemeData(
        primaryColor: Colors.green[800],
        accentColor: Colors.green[800],
      ),
      routes: {
        MapScreen.id: (context) => MapScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        
        // GroupCreateScreen.id: (context) => GroupCreateScreen(),
        // JoinGroupScreen.id: (context)=>JoinGroupScreen(),
                // GroupPageScreen.id: (context) => GroupPageScreen(DocumentSnapshot),
              },
            );
          }
        }
        
        class JoinGroup {
}