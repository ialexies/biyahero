import 'package:byahero/states/transactionstate.dart';
import 'package:flutter/material.dart';
import 'resources/app_config.dart';
import 'main.dart';
import 'package:provider/provider.dart';
import './states/appstate.dart';
import './states/mapstate.dart';

void main() {
  //create a variable for AppConfig
  var configuredApp = AppConfig(
    homePage: 1,
    appTitle: "Passengers App",
    buildFlavor: "Production",
    child: MyPassengerApp(),
    accountType: 1,
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
        ChangeNotifierProvider.value(
          value: TransactionState(),
        ),
      ],
      child: configuredApp,
    ),
  );

  // return runApp(configuredApp);
}
