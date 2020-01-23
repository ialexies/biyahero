import 'package:byahero/components/drivers/driver_pageview.dart';
import 'package:byahero/components/passenger_pageview.dart/passenger_pageview.dart';
import 'package:byahero/resources/app_config.dart';
// import 'package:byahero/screens/riders/passengerMap_screen.dart';
import 'package:byahero/screens/riders/ridersMap_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:byahero/screens/map_screeen.dart';
// import 'package:byahero/screens/test_unauth_phone.dart';
import '../controllers/helper_google_account.dart';
// import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/unauth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../states/appstate.dart';
// import 'package:byahero/screens/map_screeen.dart';

final GoogleSignIn HomeGoogleSignIn = GoogleSignIn();

class HomeScreen extends StatefulWidget {
  static const String id = 'welcome_id';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool internetStatus = false;
  int pageIndex = 0;
  PageController pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(); //generate unique key for widget

  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0);

    // Detects when user signed in
    HomeGoogleSignIn.onCurrentUserChanged.listen((account) {
      print('theres a change in google user');
      GoogleAccountHelper().handleSignIn(account, this.context);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      print('theres a change firebase user in user');
      GoogleAccountHelper().handleFirebaseSignIn(firebaseUser, this.context);
    }, onError: (err) {
      print('Error signing in: $err');
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return appState.isAuth
        ? buildAuthScreen(context)
        : buildUnAuthScreen(context);
    // : unAuthPhoneReg();
  }

  Scaffold buildUnAuthScreen(contex) {
    return Scaffold(
      body: unAuthScreen(context),
      // body:unAuthPhoneReg(),
    );
  }

  Scaffold buildAuthScreen(context) {
    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: pageViewOption(),
        controller: pageController,
        onPageChanged: onPageChanged(pageIndex),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).primaryColor,
        items: bottomNavbarOptions(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     GoogleAccountHelper().logoutgoogle();
      //     showSnackBar('Logged Out');
      //   },
      //   child: Icon(Icons.exit_to_app),
      // ),
    );
  }

  List<BottomNavigationBarItem> bottomNavbarOptions() {
    switch (AppConfig.of(context).AppConfigType()) {
      case 1:
        return passengerBottomNavBar(); //return pageview of passenger
        break;
      case 2:
        return driverBottomNavBar(); //return pageview of driver
        break;
    }
  }

  showSnackBar(String txtcontent) {
    // print("Show Snackbar here !");
    final snackBar = new SnackBar(
      content: new Text(txtcontent),
      duration: new Duration(seconds: 3),
      backgroundColor: Colors.red,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('Please connect to the Internet');
          }),
    );
    // How to display Snackbar
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  onPageChanged(int pageIndex) {
    pageIndex = pageIndex;
  }

  pageViewOption() {
    print(
        '${AppConfig.of(context).AppConfigType()}-----Type of User----------');
    // return driverHomePageViewWidget(); //return pageview of driver
    switch (AppConfig.of(context).AppConfigType()) {
      case 1:
        return passengerHomePageViewWidget(); //return pageview of passenger
        break;
      case 2:
        return driverHomePageViewWidget(); //return pageview of driver
        break;
    }
  }
}
