
import 'package:byahero/screens/map_screeen.dart';
import 'package:byahero/screens/profile_screen.dart';
// import 'package:byahero/screens/riders/ridersMap_screen.dart';
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

  List<BottomNavigationBarItem> passengerBottomNavBar() {
    return [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.map,
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


  List<Widget> passengerHomePageViewWidget() {
    return <Widget>[
        MapScreen(androidFusedLocation: true,),
        // RiderMapScreen(androidFusedLocation: true,),
        ProfileScreen(),
        SettingsScreen(),
      ];
  }