import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/map_route_form_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

class Maproute extends StatefulWidget {
  @override
  _MaprouteState createState() => _MaprouteState();
}

class _MaprouteState extends State<Maproute> {
  GoogleMapController mapController;
  static LatLng _initialGeoPosition =
      LatLng(14.828243, 120.281595); //from geo location
  LatLng _pickupLocation =
      _initialGeoPosition; //pickup location to be used for destination routing
  LatLng _destinationLocation = LatLng(14.826578, 120.282718);
  LatLng _cameraTarget = _initialGeoPosition;
  final Set<Polyline> _polyline = {};
  final Set<Marker> _markers = {};
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _getUserLocation();
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return _initialGeoPosition==null ? 
    Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 20,),
              Text("Please enable location services!", style: TextStyle(color: Colors.grey, fontSize: 18),),
            ],
          ),
        ),
      ) :
    Scaffold(
      appBar: header(context, isAppTitle: true),
      // body: circularProgress(),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _destinationLocation, zoom: 18),
            onMapCreated: onCreated,
            mapType: MapType.normal,
            markers: _markers,
            polylines: _polyline,
            onCameraMove: _onCameraMove,
          ),
          MapRouteForm(
            topLocattion: 10,
            textForm: '',
            textHint: 'Select Pick up location',
            Iconform: Icons.my_location,
            onChange: (value) {
              print(value);
            },
            frmPickupController: pickupController,
          ),
          MapRouteForm(
            topLocattion: 65,
            textForm: '',
            textHint: '',
            Iconform: Icons.motorcycle,
            onChange: (value) {
              print(value);
            },
            frmPickupController: destinationController,
          ),
          Visibility(
            visible: true,
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 140, 15, 0),
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 10, spreadRadius: 3),
                ],
              ),
              child: FutureBuilder(
                // future: mapState.getCountries,
                initialData: [],
                builder: (context, snapshot) {
                  return Text(
                      'list of suggestions'); //Replace with the design to return
                },
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 10,
            child: FloatingActionButton(
              // onPressed: _onAddMarkerPressed,
              onPressed: _locationServiceStatus,
              child: Icon(Icons.pin_drop),
            ),
          )
        ],
      ),
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _cameraTarget = position.target;
    // print(position.target);
    _onAddMarkerPressed();
  }

  void _onAddMarkerPressed() {
    // print(pickupController.text);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(_cameraTarget.toString()),
          position: _cameraTarget,
          infoWindow: InfoWindow(
            title: "Remember Here",
            snippet: "good place",
          ),
          icon: BitmapDescriptor
              .defaultMarker, //the actual design of the pin in the map
        ),
      );
    });
  }

  void _getUserLocation() async {

    // print(_locationServiceStatus());

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialGeoPosition = LatLng(position.latitude, position.longitude);
    setState(() {
      pickupController.text = placemark[0].subThoroughfare +
          ' ' +
          placemark[0].thoroughfare +
          ', ' +
          placemark[0].locality;
      
      
    });
    print(_initialGeoPosition);
  }

  _locationServiceStatus() async {
    bool status;

    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    // GeolocationStatus geolocationStatus  = await geolocator.checkGeolocationPermissionStatus();
    // return geolocationStatus;
    if (geolocationStatus == GeolocationStatus.granted) {
      status = true;
    } else if (geolocationStatus == GeolocationStatus.restricted) {
      status = false;
    }
    // print("-------------"+ status.toString());
    return "------------this is the status";
  }
}
