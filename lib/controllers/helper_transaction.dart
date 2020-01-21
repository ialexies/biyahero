// import 'dart:html';

import 'package:byahero/states/appstate.dart';
import 'package:byahero/states/mapstate.dart';
import 'package:byahero/states/transactionstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:provider/provider.dart';

class TransactionRoute {
  LatLng pickupLocation;
  LatLng destinationLocation;
  String passengerFirebaseUid;
  double travelPrice;
  BuildContext context;
  final transactionsRef = Firestore.instance.collection('transactions');
  

  TransactionRoute({
    this.pickupLocation,
    this.destinationLocation,
    this.passengerFirebaseUid,
    this.travelPrice,
    this.context,
  });

  DeleteTravelRoute({routeId}){
    transactionsRef.document(routeId).delete().then((val){}).catchError((err){
      print('error in deleteTravel $err');
    });
  }

  SaveTravelRoute() async{
    // docRef.setData({
    final mapState = Provider.of<MapState>(context);
    final appState = Provider.of<AppState>(context);
    final transactionState = Provider.of<TransactionState>(context);

    
    DocumentReference docRef = transactionsRef.document();
    var pickupGeohash =
        Geohash.encode(pickupLocation.latitude, pickupLocation.longitude);
    var destinationGeohash = Geohash.encode(
        destinationLocation.latitude, destinationLocation.longitude);

    mapState.updateWaitDriverContainer(true); //Show cirularprogress indicator

    docRef.setData({
      //     /*status
      //         1 = wating for driver
      //         2 = travelling
      //         3 = finish
      //         4 = deactivated
      //     */
      "uid": passengerFirebaseUid,
      "pickupLocation": GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
      "destinationLocation": GeoPoint(destinationLocation.latitude, destinationLocation.longitude),

      "positionPickup":{
        "geohash":pickupGeohash.toString(),
        "geopoint":GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
        },
      
      "positionDestination":{
        "geohash":pickupGeohash.toString(),
        "geopoint":GeoPoint(destinationLocation.latitude, destinationLocation.longitude),
        },
      "passangerName":  appState.getUserProfile().toString(),
      
      "price": travelPrice,
      "status": 1,
      "driver": null,
      "driverLoc":null,
      "startTime": null,
      "endTime": null,
      "created": DateTime.now().toUtc().millisecondsSinceEpoch,
      "updated": null,
    }).then((doc) {
      transactionState.setCurrentTransaction(
          transactionId: '${docRef.documentID}');
    }).catchError((error) {
      print(error);
    });
  }
}
