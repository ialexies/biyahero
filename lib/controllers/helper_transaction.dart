// import 'dart:html';

import 'package:byahero/states/mapstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geohash/geohash.dart';
import 'package:provider/provider.dart';
  


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
       this.travelPrice,
      this.context,
      });

  SaveTravelRoute() {
    // docRef.setData({
      final mapState = Provider.of<MapState>(context);

      final transactionsRef = Firestore.instance.collection('transactions');
      DocumentReference docRef =  transactionsRef.document();
      var pickupGeohash = Geohash.encode(pickupLocation.latitude, pickupLocation.longitude);
      var destinationGeohash = Geohash.encode(destinationLocation.latitude, destinationLocation.longitude);

      mapState.updateWaitDriverContainer(true); //Show cirularprogress indicator

      docRef.setData({
      //     /*status
      //         1 = wating for driver
      //         2 = travelling
      //         3 = finish
      //     */
      "uid": passengerFirebaseUid,
      "pickup": GeoPoint(pickupLocation.latitude, pickupLocation.longitude),
      "destinationLocation":  GeoPoint(destinationLocation.latitude, destinationLocation.longitude),
      "geoHashPickup":pickupGeohash.toString(),
      "geoHashDestination":destinationGeohash.toString(),
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
