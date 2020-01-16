// import 'dart:html';

import 'package:byahero/states/mapstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Transaction {
  LatLng pickupLocation;
  LatLng destinationLocation;
  String passengerFirebaseUid;
  double travelPrice;
  BuildContext context;

  Transaction(
      {this.pickupLocation,
       this.destinationLocation,
       this.passengerFirebaseUid,
       this.travelPrice
      // this.context,
      });

  SaveTravelRoute() {
    // docRef.setData({
      final transactionsRef = Firestore.instance.collection('transactions');
      DocumentReference docRef =  transactionsRef.document();

      docRef.setData({
      //     /*status
      //         1 = wating for driver
      //         2 = travelling
      //         3 = finish
      //     */

      "pickup": GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
      "destinationLocation":  GeoPoint(destinationLocation.latitude, destinationLocation.longitude),
      "uid": passengerFirebaseUid,
      "price": travelPrice,
      "status": 1,
      "driver":null,
      "startTime":null,
      "endTime":null,
      "created":DateTime.now().toUtc().millisecondsSinceEpoch,
      "updated":null,

    }).then((doc) {
      print('${docRef.documentID}');
    }).catchError((error) {
      print(error);
    });
  }
}
