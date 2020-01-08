import 'dart:async';

import 'package:byahero/states/appstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:byahero/common_widgets/placeholder_widget.dart';
import 'package:byahero/controllers/helper_design.dart';
import 'package:byahero/states/mapstate.dart';
import 'package:byahero/widgets/ma_bottom_info_content_destination.dart';
import 'package:byahero/widgets/map_bottom_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// import '../common_widgets/placeholder_widget.dart';

class MapScreen extends StatefulWidget {
  static String id = 'home_screen';
  const MapScreen({
    Key key,

    /// If set, enable the FusedLocationProvider on Android
    @required this.androidFusedLocation,
  }) : super(key: key);

  final bool androidFusedLocation;

  @override
  _MaprouteState createState() => _MaprouteState();
}

class _MaprouteState extends State<MapScreen> {
  Position _lastKnownPosition;
  Position _currentPosition;

  LatLng _latLngLastKownPosition;
  LatLng _latLngCurrentPosition;

  LatLng _pickupDropPin;
  LatLng _mapCustomLocationMarker;
  LatLng _destinationDropPin;

  bool _visipbilit_pickUDropPin = false;

  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !widget.androidFusedLocation;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        // Here you can write your code for open new view
        _lastKnownPosition = position;
        setState(() => _latLngLastKownPosition =
            LatLng(position.latitude, position.longitude));
      });
    });

    // setState(() async{
    //   _lastKnownPosition = position;
    //   setState(() => _latLngLastKownPosition =
    //       LatLng(position.latitude, position.longitude));
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !widget.androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
          setState(() => _latLngCurrentPosition =
              LatLng(position.latitude, position.longitude));
        }
      }).catchError((e) {
        //
      });
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }

          void _onAddMarkerPressed() {
            setState(() {
              // if (mapState.markers[0].){

              // }

              // mapState.markers()

              mapState.markers.add(Marker(
                markerId: MarkerId('markerPickupLocation'),
                position: _pickupDropPin,
                infoWindow:
                    InfoWindow(title: "Pick me here", snippet: "Make it fast"),
                icon: BitmapDescriptor.defaultMarker,
              ));
            });
          }

          return Stack(
            children: <Widget>[
              _latLngCurrentPosition == null
                  ? Container(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[CircularProgressIndicator()],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          // visible: appState.locationServiceActive == false,
                          child: Text(
                            "Please enable location services!",
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
                  : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _latLngCurrentPosition,
                        zoom: 16.0,
                      ),
                      onMapCreated: mapState.onCreated,
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      compassEnabled: true,
                      markers: mapState.markers,
                      // onCameraMove: mapState.onCameraMove,
                      onCameraMove: _onCameraMoves,
                      polylines: mapState.polyline,
                      trafficEnabled: true,
                    ),
              Visibility(
                //  visible: mapState.autoCompleteContainer==true,
                visible: mapState.autoCompleteContainer == true,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 180, 15, 0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 5.0),
                          blurRadius: 10,
                          spreadRadius: 3)
                    ],
                  ),
                  child: FutureBuilder(
                    future: mapState.getCountries(),
                    initialData: [],
                    builder: (context, snapshot) {
                      return createCountriesListView(context, snapshot);
                    },
                  ),
                ),
              ),
              Positioned(
                top: 500,
                child: Text(mapState.getmapCustomPickupLocation.toString()),
                
              ),
              // Positioned( //-----------test position remove later
              //   bottom: 40, right: 80,
              //   // child: FloatingActionButton(onPressed: _onAddMarkerPressed, tooltip: "Add Map",),
              //   child: FloatingActionButton(
              //     onPressed: () {
              //       _setLocation(
              //           btnTitle: "Set as Pickup Location",
              //           title: "Pickup Location",
              //           locType: 1);
              //     },
              //   ),
              // ),
              // Positioned(   //-----------test position remove later
              //   bottom: 40, right: 10,
              //   // child: FloatingActionButton(onPressed: _onAddMarkerPressed, tooltip: "Add Map",),
              //   child: FloatingActionButton(
              //     onPressed: _onAddMarkerPressed,
              //     backgroundColor: Colors.yellow,
              //     child: Icon(Icons.add_location, color: Colors.black45),
              //   ),
              // ),
              Positioned(
                top: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: appsScreenWidth(context) - 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 5.0),
                            blurRadius: 10,
                            spreadRadius: 3)
                      ],
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Container(
                              height: 90,
                              child: Column(
                                children: <Widget>[
                                  
                                  Expanded(
                                    child: Container(
                                      // child: Icon(Icons.location_on)),
                                      child: IconButton(
                                        icon: Icon(Icons.location_on),
                                        onPressed: () {
                                          setState(() {
                                            _visipbilit_pickUDropPin = true;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                        Container(child: Icon(Icons.more_vert)),
                                  ),
                                  Expanded(
                                    child: Container(
                                        child: Icon(Icons.local_taxi)),
                                  ),
                                ],
                              )),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 11,
                          child: Column(
                            children: <Widget>[
                              //Textfield for the piclup location
                              TextField(
                                
                                cursorColor: Colors.black,
                                controller: mapState.textPickupLocationController,
                                decoration: InputDecoration(
                                  hintText: "pick up",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 0, top: 16.0),
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Theme.of(context).accentColor,
                                    onPressed: (){
                                      _setLocation(
                                        btnTitle: "Set As Pickup Location",
                                        title: "Pickup Location",
                                        locType: 1
                                      );
                                    },
                                  ), 
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Divider(),
                              ),
                              //Textfield for the piclup location
                              TextField(
                                cursorColor: Colors.black,
                                controller: mapState.textDestinationControler,
                                textInputAction: TextInputAction.go,
                                onSubmitted: (value) {
                                  // mapState.autoCompleteContainer = false;
                                  // mapState.autoCompleteContainer = false;
                                  mapState.visibilityAutoComplete(false);
                                  mapState.sendRequest(value);
                                  // mapState.autoCompleteContainer = false;
                                },
                                onChanged: (value) {
                                  mapState.increment();
                                  // mapState.autoCompleteContainer = true;
                                  if (mapState.textDestinationControler.text !=
                                      null) {
                                    mapState.autoCompleteContainer = true;
                                  } else {
                                    mapState.autoCompleteContainer = false;
                                  }
                                },
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      // mapState.textDestinationControler.text="";
                                      mapState.clearDestination();
                                      // GoogleMap
                                    },
                                  ),
                                  hintText: "Choose your destination",
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 15.0, top: 16.0),
                                  prefixIcon: IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Theme.of(context).accentColor,
                                    onPressed: (){
                                      _setLocation(
                                        btnTitle: "Set As Destination Location",
                                        title: "Destination Location",
                                        locType: 2
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              mapState.destinationDistance != null
                  ? mapBottomInfo(
                      context: context,
                      screeWidth: appsScreenWidth(context),
                      var1: mapState.destinationDistance != null
                          ? true
                          : false, //visibility
                      content: destinationBottomInfoContent(
                          context: context,
                          destinationkm: mapState.destinationDistance,
                          detinationDuration: mapState.destinationDuration),
                      // var2: mapState.destinationDistance,
                      // var3: mapState.destinationDuration,
                    )
                  : Container(),
              Visibility(
                visible: _visipbilit_pickUDropPin,
                child: Positioned(
                  left: appsScreenWidth(context) * .32,
                  top: appScreenHeight(context) * .32,
                  child: Column(
                    children: <Widget>[
                      // Icon(Icons.pin_drop,size: 50,color: Colors.red,),

                      Text(
                        "Click this pin to \nconfirm pickup point",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.location_on,
                          size: 50,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _onAddMarkerPressed();
                          setState(() {
                            _visipbilit_pickUDropPin = false;
                            _latLngCurrentPosition = _pickupDropPin;
                            print(_latLngCurrentPosition);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _onCameraMoves(CameraPosition position) {
    setState(() {
      _pickupDropPin = position.target;
    });
  }
  void _onCameraMovesMapCustomLocation(CameraPosition position) {
    final mapState = Provider.of<MapState>(context);
    setState(() {
      _mapCustomLocationMarker = position.target;
      // mapState.setMapCustomLocation(position.target);
      // print(mapState.getmapCustomPickupLocation);
    });
  }
  
  //Custom location modal dialog
  Future<void> _setLocation(
    
      {int locType, String title, String btnTitle}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppBar(
            title: Text(title),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: appsScreenWidth(context) * .99,
              height: appScreenHeight(context) * .6,
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      // target: LatLng(14.838787, 120.2845745),
                      target: MapState().initalPosition,
                      zoom: 15.0,
                    ),
                    
                    // onMapCreated: mapState.onCreated,
                    myLocationEnabled: true,
                    mapType: MapType.normal,
                    compassEnabled: true,
                    // markers: {
                    //   Marker(
                    //     markerId: MarkerId("markermycurrentlocation"),
                    //     position: LatLng(14.838787, 120.2845745),
                    //   ),
                    // },
                    // onCameraMove: mapState.onCameraMove,
                    onCameraMove: _onCameraMovesMapCustomLocation,
                    // polylines: mapState.polyline,
                    trafficEnabled: true,
                  ),
                  Positioned(
                    child: Center(
                        child: Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 40,
                    )),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: FlatButton(
                color: Colors.red,
                child: Center(child: Text(btnTitle)),
                onPressed: () async{
                  final mapState = Provider.of<MapState>(context);

                  if (locType==1){
                    mapState.setMapCustomPickupLocation(_mapCustomLocationMarker);
                    mapState.textPickupLocationController.text =await  mapState.convertLatLngToPlaceText(_mapCustomLocationMarker);
                    mapState.sendRequest(mapState.textDestinationControler.text.toString());
                    Navigator.of(context).pop();
                  }else if (locType==2){
                    mapState.setMapCustomDestinationLocation(customLocation: _mapCustomLocationMarker);
                    mapState.textDestinationControler.text =await  mapState.convertLatLngToPlaceText(_mapCustomLocationMarker);
                    mapState.sendRequest(mapState.textDestinationControler.text.toString());
                    Navigator.of(context).pop();
                  } else {
                    print('**********Location Type Not Defined***********');
                  }
                  


                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
  var values = snapshot.data;
  return ListView.builder(
    shrinkWrap: true,
    itemCount: values == null ? 0 : values.length,
    itemBuilder: (BuildContext context, int index) {
      final mapState = Provider.of<MapState>(context);

      return GestureDetector(
        onTap: () {
          mapState.setMapCustomDestinationLocation( customLocation: null);
          
          // setState(() {
          // selectedCountry = values[index].code;
          mapState.selectedPlace = values[index].description;
          mapState.sendRequest(values[index].description);
          mapState.visibilityAutoComplete(false);
          // });

          mapState.textDestinationControler.text =
              mapState.selectedPlace.toString();
          // mapState.sendRequest(mapState.toString());
          mapState.sendRequest(mapState.textDestinationControler.text.toString());
          //  mapState.sendRequest(value);
          // print(values[index].code);
          // print(mapState.selectedPlace);
        },
        child: Column(
          children: <Widget>[
            new ListTile(
              title: Text(values[index].description),
            ),
            Divider(
              height: 2.0,
            ),
          ],
        ),
      );
    },
  );
}
