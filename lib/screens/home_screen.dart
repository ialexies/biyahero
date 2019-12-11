import 'package:flutter/material.dart';
import 'package:fluttershare/screens/map_screeen.dart';
import '../controllers/helper_google_account.dart';
// import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/unauth_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../states/appstate.dart';
import 'package:fluttershare/screens/map_screeen.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();


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
    googleSignIn.onCurrentUserChanged.listen((account) {
      print('changes in user-------------');
      GoogleAccountHelper().handleSignIn(account, this.context);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    // Reauthenticate user when app is opened
    // googleSignIn.signInSilently(suppressErrors: false).then((account) {
    //   GoogleAccountHelper().handleSignIn(account,this.context);
    // }).catchError((err) {
    //   print('Error signing in: $err');
    // });
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
  }

    Scaffold buildUnAuthScreen(contex) {
    return Scaffold(
      body: unAuthScreen(context),
    );
  }

  Scaffold buildAuthScreen(context) {
    

    return Scaffold(
      key: _scaffoldKey,
      body: PageView(
        children: <Widget>[
          MapScreen(),
          ProfileScreen(),
          SettingsScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged(pageIndex),
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.blueGrey,
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map,color: Colors.white,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle,color: Colors.white,),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,color: Colors.white,),
          ),
        ],
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


}
