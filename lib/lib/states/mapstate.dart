
import 'dart:ffi';

import 'package:byahero/states/appstate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:byahero/controllers/map_controller.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/google_maps_request.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MapState with ChangeNotifier{
  bool locationServiceActive = true;
  static LatLng _initialPosition; ///position fromg geolocation
  LatLng _mapCustomPickupLocation;  //custom location of pickup via pin
  LatLng _mapCustomDestinationLocation;  //custom location of destination  via pin
  double  _initialPositionLat; ///position fromg geolocation
  double  _initialPositionLong; ///position fromg geolocation
  LatLng _lastPosition = _initialPosition; /// destination via search

  LatLng _finalPickupLocation;
  LatLng _finalDestinationLocation;
  bool visibilityDriverWait=false; //visibility of black widget container when waiting for driver

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  GoogleMapController _mapController;
  double destinationDistance;
  String destinationDuration;

  bool _destinationBottomInfo = false;
 
  int _regPriceKm;
  int _minimumPrice;



  //for autocomplete
  List <SuggestedPlaces> _autoComplete ;
  String selectedPlace = "sm";
  bool autoCompleteContainer = false;
  final priceRef = Firestore.instance.collection('prices');

  // Setters
  GoogleMapsServices _googleMapServices  = GoogleMapsServices();
  TextEditingController textPickupLocationController =TextEditingController();
  TextEditingController textDestinationControler=TextEditingController();
  // num _autoComplete = 0;

  // Getters
  LatLng get initalPosition => _initialPosition;
  double get initalPositionLat => _initialPositionLat;
  double get initalPositionLong => _initialPositionLong;
  LatLng get lastPosition => _lastPosition;
  LatLng get getmapCustomPickupLocation => _mapCustomPickupLocation;
  LatLng get getFinalPickupLocation => _finalPickupLocation;
  LatLng get getFinalDestinationLocation => _finalDestinationLocation;


  GoogleMapsServices get googleMapServices => _googleMapServices;
  GoogleMapController get mapController =>_mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyline => _polyLines;
  List <SuggestedPlaces> get autocomplete => _autoComplete;
  bool get destinationBottomInfo => _destinationBottomInfo;

  getregPriceKm() => _regPriceKm;
  getminimumPrice() => _minimumPrice;

  //constructor for getuserlocation
  MapState() {
    getUserLocation();
    _loadingInitialPosition();
    initPrices();
  }

  @override
  void updateWaitDriverContainer( bool val){

    if (val==true){
      visibilityDriverWait=true;
      notifyListeners();
    }
     if (val==false){
      visibilityDriverWait=false;
       notifyListeners(); 
    }
  }

  getDriverWaitVal(){
    return  visibilityDriverWait;
  }


  //---------------- Final Pickup and Destination Functions---------------------------//

  void setFinalPickupLocation(LatLng finalPickupLocation){
    _finalPickupLocation = finalPickupLocation;
    notifyListeners();
  }

  void setFinalDestinationLocation(LatLng finalDestinationLocation){
    _finalDestinationLocation = finalDestinationLocation;
    notifyListeners();
  }

  getFinaPickupLocationtest(){
    return _finalPickupLocation;
  }

  //---------------- End of Final Pickup and Destination Functions---------------------------//



  void setMapCustomPickupLocation(LatLng customLocation){
    _mapCustomPickupLocation = customLocation;
    notifyListeners();
  }

  void setMapCustomDestinationLocation({LatLng customLocation}){
    if (customLocation!=null){
      _mapCustomDestinationLocation = customLocation;
      notifyListeners();
    }else if (customLocation==null){
      _mapCustomDestinationLocation = null;
    }
    
    // notifyListeners();
  }


    void initPrices({double regKMprice, double minimumPrice})async{
      var document = await Firestore.instance.collection('appconfigs').document('prices').get();

      print(document.data);

      // document.get() => then((){
      //   print();
      // });

      // Stream<DocumentSnapshot> prices = Firestore.instance.collection('appconfigs').document('prices').snapshots();

    // _regPriceKm =  regKMprice;
    _regPriceKm =  document.data['perKm'];
    _minimumPrice = document.data['minimum'];
    notifyListeners();
  } 

  void increment() async{
    // _autoComplete +=1;
    // _autoComplete += "blah " ;

    _autoComplete = await getCountries();

    // debugPrint(_autoComplete.toString());

    notifyListeners();
  }

 

  void getUserLocation() async{
  
    //set initial position variables
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // List<Placemark> placemark =  await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude); 
    _initialPosition=LatLng(position.latitude, position.longitude); 
    _initialPositionLat = position.latitude.toDouble();
    _initialPositionLat = position.longitude.toDouble();


    // await convertLatLngToPlaceText();
   

    textPickupLocationController.text = await  convertLatLngToPlaceText(_initialPosition);
  


    notifyListeners();
  }

  //convert LatLng to Text place location
   Future convertLatLngToPlaceText(LatLng position) async{
    List<Placemark> placemark;
    try {
      placemark =  await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude ); 
      print('Awaiting user order...');
    } catch (err) {
      print('Caught error: $err');
    }
    // return textPickupLocationController.text = placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare + ', ' +placemark[0].locality;
    // var textReturn =  placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare + ', ' +placemark[0].locality;

    // return textReturn;

    if(placemark!=null){
      return textPickupLocationController.text = placemark[0].subThoroughfare + ' ' + placemark[0].thoroughfare + ', ' +placemark[0].locality;
    }else{
      return 'Location Not Registered';
    }

  }

  
  void _loadingInitialPosition()async{
    await Future.delayed(Duration(seconds: 8)).then((v) {
      if(_initialPosition == null){
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }


  // On Create
  void onCreated(GoogleMapController controller) { 
    _mapController = controller;
    notifyListeners();
  }
                

  //Add Marker in Map
  void _addMarker({LatLng location, MarkerId id, String title, String snippet, String address,BitmapDescriptor markerIcon}) async{
    _markers.add(
      Marker(
        markerId:id,
        position: location,
        infoWindow: InfoWindow( 
          title: title,
          snippet: snippet,
        ),
        // icon:  await  BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(150, 150)),"images/car-finish-flag.png"),
        icon:  markerIcon,
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
    _destinationBottomInfo=false;
    // textDestinationControler.text;
    textDestinationControler.text="";
    
  }

  // When the user type something in the textbox it will show the placemark 
  void sendRequest(String intendedLocation)async{

     _markers.clear();
    _polyLines.clear();
    // List<Placemark> placemark ;
     List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation.toString()); 
       double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    String destinationPolyline;
    // LatLng finalPickupLocation = initalPosition;
    // LatLng finalDestinationLocation = destination;
    setFinalPickupLocation(initalPosition);
    setFinalDestinationLocation( destination);

    //Check if there's a custom pickup location and use it
    if(_mapCustomPickupLocation!=null){
      // finalPickupLocation = _mapCustomPickupLocation;
      setFinalPickupLocation(_mapCustomPickupLocation);
      notifyListeners();
    }

    if(_mapCustomDestinationLocation!=null){
      // finalDestinationLocation = _mapCustomDestinationLocation; 
      setFinalDestinationLocation(_mapCustomDestinationLocation);
    }else if(_mapCustomDestinationLocation==null){
      setFinalDestinationLocation( destination);
      notifyListeners();
    }

    // //Set the global use of final route Pickup & Destination
    // setFinalPickupLocation(finalPickupLocation);
    // setFinalDestinationLocation(finalDestinationLocation);
    // notifyListeners();
    
  
    // Get the Route data from google using the current position and destionation
    // Map<String, dynamic> route  = await _googleMapServices.getRouteCoordinates(initalPosition, destination);
    
    Map<String, dynamic> route  = await _googleMapServices.getRouteCoordinates(_finalPickupLocation, _finalDestinationLocation);
    print('$_finalPickupLocation---------------');
    print('$_finalDestinationLocation---------------');
    // Map<String, dynamic> route  = await _googleMapServices.getRouteCoordinates(_finalPickupLocation, _finalDestinationLocation);

    // Get the the Distance from the destination in km/
    destinationDistance = (route['legs'][0]['distance']['value'])/1000;
    print("Your destination is ${destinationDistance/1000} km");

    //Get the destionations time duration
    destinationDuration = route['legs'][0]['duration']['text'];

    // Get the polylines of the route to destination
    destinationPolyline = route["overview_polyline"]["points"];
 
    // createRoute(route) using the polyline;
    createRoute(destinationPolyline);

    // _addMarker for destination
    _addMarker(
      location: destination, 
      id: MarkerId('destinationLocationMarker'),
      markerIcon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(150, 150)),"images/car-finish-flag.png")
      );

    // _addMarker for pickup
    _addMarker(
      location: _finalPickupLocation, 
      id: MarkerId('pickupLocationMarker'),
      markerIcon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(250, 250)),"images/pickupmarker.png")

      );

    _destinationBottomInfo=true;
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
    // final response = await http .get('https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU&input=${textDestinationControler.text}');
    // The location is filter for suggestion is restricted for 50km with center at olongapo city hall as LatLng
    final response = await http .get('https://maps.googleapis.com/maps/api/place/queryautocomplete/json?key=AIzaSyB8jxZ33qr3HXTSKgXqx0mXbzQWzLjnfLU&location=14.842299, 120.287810&radius=1000&input=${textDestinationControler.text.toString()}');



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