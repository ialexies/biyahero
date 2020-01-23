import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/src/point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  Stream<List<DocumentSnapshot>> stream ;
  String position = "positionPickup";
  
  @override
  void initState() {
    super.initState();

    GeoFirePoint myLocation = geo.point(latitude: 14.8261296, longitude:120.2821852);
    geoRef = geo.collection(collectionRef: collectionReference);
    radius = 1000;
    stream = geo.collection(collectionRef: collectionReference).within(center: myLocation, radius: radius, field: position );
    
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body:  
          SizedBox(
            height: 900,
            child: StreamBuilder(
            stream: stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshots) {
              if (snapshots.connectionState == ConnectionState.active &&
                  snapshots.hasData) {
                print('data ${snapshots.data[0].data.toString()}');
                // final  List<Text>  children  =    snapshots.data[0].data
	              //           .map((doc)  =>  Text(doc['uid']))
                //         .toList();
                // List<Text> children = snapshots.data[0].data.map((doc)=>Text(doc['uid'])).toString();
                
                // return  ();
                List<Text> children = List();

                // snapshots.data[0].data.forEach(doc)=>Text(doc['username']); 
                List<Card> weightData =
snapshots.data.map( (doc) => 

Card(
  child: Column(
    children: <Widget>[
      ListTile(
        leading: Icon(Icons.album),
        title: Text(doc['uid']),
        subtitle: Column(
          children: <Widget>[
            // Text(doc['pickup']),
            Text(' Pickup ${doc.data["pickup"].longitude.toString()}' ),  
          ],
        ),
      )
    ],
  ),
)).toList();
// Container(
  

//   doc['uid'].toString())).toList();


                return ListView(
                  children: weightData  ,
                );
                // return Text(snapshots.data.forEach((doc)=>debugPrint(doc.data.toString())));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          ),
        
      ),
    );
  }
}