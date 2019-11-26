import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:provider/provider.dart';
// import '../states/state_map.dart';
import 'states/state_map.dart';
// import 'package:geolocator/geolocator.dart';



// void main() {
//   runApp(MyApp());
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MultiProvider(providers: [
      ChangeNotifierProvider.value(value: AppState(),)
  ],
  child: MyApp(),));
}



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
