import 'package:byahero/states/mapstate.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Transaction{
  LatLng pickupLocation;
  LatLng destinationLocation;
  String passengerFirebaseUid;
  int travelPrice;
  BuildContext context;

  Transaction({
     this.pickupLocation,
  this.destinationLocation,
    this.passengerFirebaseUid,
  this.travelPrice
    // this.context,
  });

  printInfo(){
    // print(MapState.);
  }

}