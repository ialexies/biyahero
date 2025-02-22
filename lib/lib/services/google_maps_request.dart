import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart'; //convert json 
const   apiKey = "AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU";

class GoogleMapsServices{
    Future<Map<String, dynamic>> getRouteCoordinates(LatLng l1, LatLng l2)async{
      String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&avoid=highways&region=ph&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
      // String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&avoid=highways&region=ph&mode=bicycling&destination=${l2.latitude},${l2.longitude}&key=$apiKey";
      http.Response response = await http.get(url);
      Map values = jsonDecode(response.body);

      return values["routes"][0];
   
    }
}