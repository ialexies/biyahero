
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershare/controllers/map_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/google_maps_request.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MapState with ChangeNotifier{
  static LatLng _initialPosition;
  double  _initialPositionLat;
  double  _initialPositionLong;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  double destinationDistance;
  String destinationDuration;

  //for autocomplete
  List <SuggestedPlaces> _autoComplete ;
  String selectedPlace = "sm";
  bool autoCompleteContainer = false;

  // Setters
  GoogleMapsServices _googleMapServices  = GoogleMapsServices();
  TextEditingController locationController =TextEditingController();
  TextEditingController destinationControler=TextEditingController();
  // num _autoComplete = 0;

  // Getters
  LatLng get initalPosition => _initialPosition;
  double get initalPositionLat => _initialPositionLat;
  double get initalPositionLong => _initialPositionLong;
  LatLng get lastPosition => _lastPosition;
  GoogleMapsServices get googleMapServices => _googleMapServices;
  GoogleMapController get mapController =>_mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polyLines;
  List <SuggestedPlaces> get autocomplete => _autoComplete;



  //constructor for getuserlocation
  MapState(){
    _getUserLocation();
  }


  void increment() async{
    // _autoComplete +=1;
    // _autoComplete += "blah " ;

    _autoComplete = await getCountries();

    // debugPrint(_autoComplete.toString());

    notifyListeners();
  }

 

  void _getUserLocation() async{
    List<Placemark> placemark;
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    // List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude); 

    try {
      placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude); 
      print('Awaiting user order...');
    } catch (err) {
      print('Caught error: $err');
    }

     


      _initialPosition=LatLng(position.latitude, position.longitude); 
      _initialPositionLat = position.latitude.toDouble();
      _initialPositionLat = position.longitude.toDouble();


      locationController.text = placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare + ', ' +placemark[0].locality;
      notifyListeners();
  }
  

  // On Create
  void onCreated(GoogleMapController controller) { 
    _mapController = controller;
    notifyListeners();
  }
                


  //Add Marker in Map
  void _addMarker(LatLng location, String address) async{
    _markers.add(
      Marker(
        markerId:MarkerId(_lastPosition.toString()),
        position: location,
        infoWindow: InfoWindow( 
          title: "Address",
          snippet: "Go Here",
        ),
        icon: await  BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(150, 150)),"images/car-finish-flag.png"),
      ),
    ); 
    notifyListeners();
  }  

  //On Camera Move
  void onCameraMove(CameraPosition position) {
      _lastPosition = position.target; 
      notifyListeners();
  }   


  void clearDestination(){
     _markers.clear();
    _polyLines.clear();
    destinationControler.clear();
    
  }

    Future<List<Placemark>> getPlacemark(intendedLocation) async{
        var places  = await Geolocator().placemarkFromAddress(intendedLocation); 
        
        return places ;
      }

  // When the user type something in the textbox it will show the placemark 
  void sendRequest(String intendedLocation)async{
    // List<Placemark> placemark ;
    //  List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation); 
     List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation); 

     //clear all previous markings
    _markers.clear();
    _polyLines.clear();

    //Initiate variable 
    
    String destinationPolyline;
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);

    // Get the Route data from google using the current position and destionation
    Map<String, dynamic> route  = await _googleMapServices.getRouteCoordinates(initalPosition, destination);

    // Get the the Distance from the destination in km/
    destinationDistance = (route['legs'][0]['distance']['value'])/1000;
    print("Your destination is ${destinationDistance/1000} km");

    //Get the destionations time duration
    destinationDuration = route['legs'][0]['duration']['text'];

    // Get the polylines of the route to destination
    destinationPolyline = route["overview_polyline"]["points"];
 
    // createRoute(route) using the polyline;
    createRoute(destinationPolyline);
    _addMarker(destination, intendedLocation); 
    notifyListeners();
  }


  //Create Polyline as Map Route
  void createRoute(String encodedPoly){
    // _polyLines.clear();
      _polyLines.add(Polyline(
        polylineId: PolylineId(_lastPosition.toString()),
        width: 3,
        points: AppMapController().convertToLatLng(AppMapController().decodePoly(encodedPoly)),
        color: Colors.black),
      );
      notifyListeners();
  } 
  

  void visibilityAutoComplete(bool visibleAutoComplete){
    autoCompleteContainer = visibleAutoComplete;
    notifyListeners();
  }

  //list of place predictions of suggestion based on typed location
  Future<List<SuggestedPlaces>>getCountries() async{
    // final response = await http .get('https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU&input=${destinationControler.text}');
    // The location is filter for suggestion is restricted for 50km with center at olongapo city hall as LatLng
    final response = await http .get('https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU&location=14.842299, 120.287810&radius=1000&input=${destinationControler.text}');

    if(response.statusCode == 200){
      var parsedPlacesList = json.decode(response.body);

      List<SuggestedPlaces> suggestedPlaces = List<SuggestedPlaces>();

      parsedPlacesList["predictions"].forEach((suggestedPlace){
        suggestedPlaces.add(SuggestedPlaces.fromJSON(suggestedPlace));
      });
      
      return suggestedPlaces;
    }else{
      throw Exception('Failed to load');
    }
  }

}

class SuggestedPlaces {
  String description;

  SuggestedPlaces({this.description,});

  factory SuggestedPlaces.fromJSON(Map<String,dynamic>json){
    return SuggestedPlaces(
      description: json['description'],
    );
  }


}