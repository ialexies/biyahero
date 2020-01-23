
import 'package:byahero/screens/profile_screen.dart';
import 'package:byahero/screens/riders/findPassenger_screen.dart';
import 'package:byahero/screens/riders/ridersMap_screen.dart';
import 'package:byahero/screens/settings_screen.dart';
import 'package:flutter/material.dart';


// class homePageViewWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return <Widget>[
//         // MapScreen(androidFusedLocation: true,),
//         RiderMapScreen(androidFusedLocation: true,),
//         ProfileScreen(),
//         SettingsScreen(),
//       ];
//   }
// }


    List<BottomNavigationBarItem> driverBottomNavBar() {
    return [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.search,
        color: Colors.black87,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.account_circle,
        color: Colors.black87,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
        color: Colors.black87,
      ),
    ),
  ];
  }







  List<Widget> driverHomePageViewWidget() {
    return <Widget>[
        // MapScreen(androidFusedLocation: true,),
        FindPassengerScreeen(),
        // RiderMapScreen(androidFusedLocation: true,),
        ProfileScreen(),
        SettingsScreen(),
      ];
  }