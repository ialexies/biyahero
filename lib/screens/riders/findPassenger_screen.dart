import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import '../../widgets/header.dart';
import '../../controllers/helper_google_account.dart';
import 'package:rxdart/rxdart.dart';

final transactionsRef = Firestore.instance.collection('transactions');
List<String> waitingPassengers = [];

class FindPassengerScreeen extends StatefulWidget {
  @override
  FindPassengerScreeenState createState() => FindPassengerScreeenState();
}

class FindPassengerScreeenState extends State<FindPassengerScreeen> {
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject(seedValue: 1.0);
  List events = [];

  @override
  void initState() {
    super.initState();
    
    // var radius = BehaviorSubject(seedValue: 1.0);
    // var radius = BehaviorSubject(seedValue: 1.0);

    // stream = radius.switchMap((rad) {
    //   var collectionReference = _firestore.collection('transactions');
    //   // return geo.collection(collectionRef: collectionReference).within(
    //   //     center: center, radius: rad, field: 'pickup', strictMode: true);
    //   return geo
    //       .collection(collectionRef: collectionReference)
    //       .within(center: center, radius: rad, field: 'pickup');
    // });
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

  Widget geoQuery() {
    var collectionReference = _firestore.collection('transactions');
      geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: 14.8268678, longitude: 120.2814242);

      // GeoFirePoint center = geo.point(
      //   latitude: widget.latitude,
      //   longitude: widget
      //       .longitude); 
    stream = radius.switchMap((rad) {
      var collectionReferencequery =
          collectionReference.where("status", isEqualTo: 1);
      return geo.collection(collectionRef: collectionReferencequery).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });

      return Column(
        children: <Widget>[
          StreamBuilder(
            stream: stream,
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (!snapshot.hasData) {
                Text("No data");
              }
              events =
                  snapshot.data.map((doc) =>  Text(doc['pickup'])).toList()   ;
              events.sort((a, b) {
                var aDate = a.timestamp;
                var bDate = b.timestamp;
                return aDate.compareTo(bDate);
              });
              if (events.isEmpty) {
                return Text("No events");
              }
              return Flexible(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    // return buildEvent(index);
                    return new Text(events[1]);
                  },
                ),
              );
            },
          )
        ],
      );
    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appHeader(context,
          titleText: 'Find Passenger', removeBackButton: true),
      body: geoQuery(),
      
      // StreamBuilder(
      //   stream: stream,
      //   builder: (BuildContext context,
      //       AsyncSnapshot<List<DocumentSnapshot>> snapshots) {
      //     if (snapshots.connectionState == ConnectionState.active &&
      //         snapshots.hasData) {
      //       print('data ${snapshots.data}');
      //       return Container();
      //     } else {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),

      // StreamBuilder<QuerySnapshot>(
      //   stream: transactionsRef.snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return CircularProgressIndicator();
      //     }
      //     final List<Container> children =
      //         // snapshot.data.documents.map((doc) => Text(doc['uid'])).toList();
      //         snapshot.data.documents.map((doc) => Container(
      //           child: Card(
      //             child: Column(
      //               children: <Widget>[
      //                 ListTile(
      //                   leading: Icon(Icons.album),
      //                   title:Text(doc['uid']),
      //                 )
      //               ],
      //             ),
      //           ),
      //         )).toList();

      //     return ListView(
      //       children: children,
      //     );
      //   },
      // ),
    );
  }
}
