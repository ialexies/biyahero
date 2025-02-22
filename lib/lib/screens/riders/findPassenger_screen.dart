import 'package:byahero/states/appstate.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/src/point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

// Init firestore and geoFlutterFire
Geoflutterfire geo = Geoflutterfire();
Firestore _firestore = Firestore.instance;

class FindPassengerScreeen extends StatefulWidget {
  @override
  _FindPassengerScreeenState createState() => _FindPassengerScreeenState();
}

class _FindPassengerScreeenState extends State<FindPassengerScreeen> {
  var collectionReference = _firestore.collection('transactions');
  var geoRef;
  double radius; //km radius
  Stream<List<DocumentSnapshot>> stream;
  String position = "positionPickup";

  @override
  void initState() {
    super.initState();

    GeoFirePoint myLocation =
        geo.point(latitude: 14.8261296, longitude: 120.2821852);
    geoRef = geo.collection(collectionRef: collectionReference);
    radius = 50;
    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: myLocation, radius: radius, field: position);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Find Passenger'),
        ),
        body: SizedBox(
          height: 900,
          child: StreamBuilder(
            stream: stream,
            builder: (BuildContext context, AsyncSnapshot<List<DocumentSnapshot>> snapshots) {
              // if (snapshots.connectionState == ConnectionState.active &&
              //     snapshots.hasData) {

       

              if (snapshots.connectionState == ConnectionState.active) {

                if(snapshots.data.length==0){
                  return Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(height: 30,),
                      Text('No Passengers'),
                    ],
                  ));
                  print('************no data');
                }
                else{
                  List<Card> weightData;

                    weightData = snapshots.data
                    .map((doc) => Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.album),
                                title: Text(doc['passangerInfo']["username"].toString()),
                                subtitle: Column(
                                  children: <Widget>[
                                    Text(
                                        'Pickup: ${doc.data["positionPickup"]["geopoint"].latitude.toString()}, ${doc.data["positionPickup"]["geopoint"].latitude.toString()}'),
                                    Text(
                                        'Pickup: ${doc.data["positionDestination"]["geopoint"].latitude.toString()}, ${doc.data["positionDestination"]["geopoint"].latitude.toString()}'),
                                    Text(
                                        ' Price" ${doc.data["price"].toString()}'),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))
                    .toList();
                return ListView(
                  children: weightData,
                );
                }
              }
              
       
           
          

      
                // return Text(snapshots.data.forEach((doc)=>debugPrint(doc.data.toString())));
        
            },
          ),
        ),
      ),
    );
  }
}
