import 'package:flutter/material.dart';
<<<<<<< HEAD
<<<<<<< HEAD
import './screens/group_join_screen.dart';
import './screens/group_page_screen.dart';
import './screens/group_create_screen.dart';
import './screens/home_screen.dart';
import './screens/registration_screen.dart';
=======
import 'package:fluttershare/pages/home.dart';
>>>>>>> parent of 99efc51... with new format from blog desin
=======
import 'package:fluttershare/pages/home.dart';
>>>>>>> parent of 99efc51... with new format from blog desin
import 'package:provider/provider.dart';
// import '../states/state_map.dart';
import 'states/state_map.dart';
// import 'package:geolocator/geolocator.dart';



// void main() {
//   runApp(MyApp());
// }



void main() {
  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then((_) {
    // print("Timestamps enabled in snapshots\n");
  }, onError: (_) {
    // print("Error enabling timestamps in snapshots\n");
  });
  WidgetsFlutterBinding.ensureInitialized();

    return runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AppState(),)
  ],
  child: MyApp(),));
}


// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   return runApp(MultiProvider(providers: [
//       ChangeNotifierProvider.value(value: AppState(),)
//   ],
//   child: MyApp(),));
// }



class MyApp extends StatelessWidget {
  // check if user is logged in
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByaHero',
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primaryColor: Colors.purple.withGreen(20),
        accentColor: Colors.teal,
      ),
    );
  }
}
