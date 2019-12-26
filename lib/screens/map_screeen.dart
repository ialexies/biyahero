import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/common_widgets/placeholder_widget.dart';
import 'package:fluttershare/controllers/helper_design.dart';
import 'package:fluttershare/states/mapstate.dart';
import 'package:fluttershare/widgets/ma_bottom_info_content_destination.dart';
import 'package:fluttershare/widgets/map_bottom_info.dart';
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
  LatLng _destinationDropPin;

  bool _visipbilit_pickUDropPin=false;

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

    setState(() {
      _lastKnownPosition = position;
      setState(() => _latLngLastKownPosition =
          LatLng(position.latitude, position.longitude));
    });
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

<<<<<<< HEAD
    return mapState.initalPosition == null? 
      Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Visibility(
                visible: mapState.locationServiceActive==true,
                child: Text('Check if the location services (GPS) are enabled', style: TextStyle(color: Colors.grey, fontSize: 18),),
              ),
              SizedBox(height: 20,),
              // Text("Please enable location services!", style: TextStyle(color: Colors.grey, fontSize: 18),),
              // FloatingActionButton(
              //   onPressed: (){
              //     mapState.getUserLocation();
              //     // print('fdf');
              //   },
              // )
            ],
          ),
        ),
      ) :
      Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: mapState.initalPosition,   zoom: 16.0,),
            onMapCreated: mapState.onCreated,
            myLocationEnabled: true,
            mapType: MapType.normal,
            compassEnabled: true,
            markers: mapState.markers,
            onCameraMove: mapState.onCameraMove,
            polylines: mapState.polyline,
            trafficEnabled: true,
            
          ),
           Visibility(
            //  visible: mapState.autoCompleteContainer==true,
             visible: mapState.autoCompleteContainer==true,
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
                    builder: (context,snapshot){
                      return  createCountriesListView(context, snapshot);
                    },
                  ),
              ),
           ),

            Positioned(

              top: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  width: appsScreenWidth(context)-60,
                  height: 130,
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
                    child: 
                    Container(
                      height: 90,
                 
                      child: Column(
                        children: <Widget>[
                            Expanded(
                              child: Container( child: Icon(Icons.location_on)),
                            ),
                            Expanded(
                              child:Container( child: Icon(Icons.more_vert)),
                            ),
                            Expanded(
                              child:Container( child: Icon(Icons.local_taxi)),
                            ),

                        ],
                      )),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 11,
                    child: Column(
                    children: <Widget>[
                      TextField(
                        cursorColor: Colors.black,
                        controller: mapState.locationController,
                        decoration: InputDecoration(
                   
                          hintText: "pick up",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10 ),
                        child: Divider(),
                      ),
                      TextField(
                    
                    cursorColor: Colors.black,
                    controller:  mapState.destinationControler,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) {
                      // mapState.autoCompleteContainer = false;
                      // mapState.autoCompleteContainer = false;
                      mapState.visibilityAutoComplete(false);
                      mapState.sendRequest(value);
                      // mapState.autoCompleteContainer = false;
                    },
                    onChanged: (value){
                      mapState.increment();
                      // mapState.autoCompleteContainer = true;
                      if(mapState.destinationControler.text!=null){
                        mapState.autoCompleteContainer = true;
                      }else{
                        mapState.autoCompleteContainer = false;
                      }
                    },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear,color: Colors.black87,),
                        onPressed: (){
                          // mapState.destinationControler.text="";
                          mapState.clearDestination();
                          // GoogleMap
                          
                        },
                      ),

                      hintText: "Choose your destination",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                    ],
                  ),
                  ),
                ],
            ),
                ),
              ),
=======
          if (snapshot.data == GeolocationStatus.denied) {
            return const PlaceholderWidget('Access to location denied',
                'Allow access to the location services for this App using the device settings.');
          }
>>>>>>> 47029f4cf61f0c7b140c0c47738566220b7bc62e

     

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
              GoogleMap(
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
                                bottom: 40, right: 10,
                                // child: FloatingActionButton(onPressed: _onAddMarkerPressed, tooltip: "Add Map",),
                                child: FloatingActionButton(
                                  onPressed: _onAddMarkerPressed,
                                  backgroundColor: Colors.yellow,
                                  child: Icon(Icons.add_location, color: Colors.black45),
                                ),
                              ),
                              Positioned(
                                top: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Container(
                                    width: appsScreenWidth(context) - 60,
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
                                                          onPressed: (){
                                                            setState(() {
                                                              _visipbilit_pickUDropPin=true;
                                                            });
                                                          },
                                                        ),),
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
                                              TextField(
                                                cursorColor: Colors.black,
                                                controller: mapState.locationController,
                                                decoration: InputDecoration(
                                                  hintText: "pick up",
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 15.0, top: 16.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Divider(),
                                              ),
                                              TextField(
                                                cursorColor: Colors.black,
                                                controller: mapState.destinationControler,
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
                                                  if (mapState.destinationControler.text !=
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
                                                      // mapState.destinationControler.text="";
                                                      mapState.clearDestination();
                                                      // GoogleMap
                                                    },
                                                  ),
                                                  hintText: "Choose your destination",
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 15.0, top: 16.0),
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
                                      left: appsScreenWidth(context)*.32,
                                      top: appScreenHeight(context)*.32,
                                      child: Column(
                                        children: <Widget>[
                                          // Icon(Icons.pin_drop,size: 50,color: Colors.red,),
                                          
                                          Text("Click this pin to \nconfirm pickup point",textAlign:TextAlign.center,),
                                          SizedBox(height: 10,),
                                          IconButton(
                                            icon: Icon(Icons.location_on,size: 50,color: Colors.red,),
                                            onPressed: (){
                                              _onAddMarkerPressed();
                                              setState(() {
                                                _visipbilit_pickUDropPin = false;
                                                _latLngCurrentPosition= _pickupDropPin;
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
                
<<<<<<< HEAD
          //       cursorColor: Colors.black,
          //       controller:  mapState.destinationControler,
          //       textInputAction: TextInputAction.go,
          //       onSubmitted: (value) {
          //         // mapState.autoCompleteContainer = false;
          //         // mapState.autoCompleteContainer = false;
          //         mapState.visibilityAutoComplete(false);
          //         mapState.sendRequest(value);
          //         // mapState.autoCompleteContainer = false;
          //       },
          //       onChanged: (value){
          //         mapState.increment();
          //         // mapState.autoCompleteContainer = true;
          //         if(mapState.destinationControler.text!=null){
          //           mapState.autoCompleteContainer = true;
          //         }else{
          //           mapState.autoCompleteContainer = false;
          //         }
          //       },
          //       decoration: InputDecoration(
          //         suffixIcon: IconButton(
          //           icon: Icon(Icons.delete),
          //           onPressed: (){
          //             // mapState.destinationControler.text="";
          //             mapState.clearDestination();
          //             // GoogleMap
                      
          //           },
          //         ),
          //         icon: Container(
          //           margin: EdgeInsets.only(left: 20, top: 5),
          //           width: 10,
          //           height: 10,
          //           child: Icon(
          //             Icons.local_taxi,
          //             color: Colors.black,
          //           ),
          //         ),
          //         hintText: "destination?",
          //         border: InputBorder.none,
          //         contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          //       ),
          //     ),
          //   ),
          // ),
          
          mapState.destinationDistance!=null? 
          mapBottomInfo(
            context: context,
            screeWidth: appsScreenWidth(context), 
            var1: mapState.destinationDistance!=null? true:false, //visibility
            content: destinationBottomInfoContent(context: context, destinationkm: mapState.destinationDistance, detinationDuration:mapState.destinationDuration ),
            // var2: mapState.destinationDistance,
            // var3: mapState.destinationDuration,
            ): Container(),
          // Positioned  (
          //   bottom: 0,
          //   // height: 60,
          //   width: appsScreenWidth(context),
          //   child: Visibility(
          //     visible: mapState.destinationDistance!=null? true:false, 
          //       child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Container(
          //         color: Colors.black.withOpacity(.4),
          //         child: Column(
          //           children: <Widget>[
          //             Padding(
          //               padding: const EdgeInsets.all(5.0),
          //               child: Column(
          //                 children: <Widget>[
          //                   Text(
          //                     '${mapState.destinationDistance.toString()}Km / ${mapState.destinationDuration} to your destination ',
          //                     textAlign: TextAlign.right,
          //                     style: TextStyle(
          //                       color: Colors.white
          //                     ),
          //                   ),
          //                   Text(
          //                     'Your Driver is Juan Dela Cruz',
          //                     textAlign: TextAlign.right,
          //                     style: TextStyle(
          //                       color: Colors.white
          //                     ),
          //                   ),
          //                 ],
          //               ),
                        
          //             ),
                    
          //             // Text('${mapsta} to your destination ',textAlign: TextAlign.right,),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 40, right: 10,
          //   // child: FloatingActionButton(onPressed: _onAddMarkerPressed, tooltip: "Add Map",),
          //   child: FloatingActionButton( 
          //     onPressed: _onAddMarkerPressed,
          //     backgroundColor: Black,
          //     child: Icon(Icons.add_location,color:White),
          //     ),
          // ),
        ],
      );
=======
                  void _onCameraMoves(CameraPosition position) {
>>>>>>> 47029f4cf61f0c7b140c0c47738566220b7bc62e


                              
                    setState(() {
                      _pickupDropPin = position.target;
                    });
                
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
          // setState(() {
          // selectedCountry = values[index].code;
          mapState.selectedPlace = values[index].description;
          mapState.sendRequest(values[index].description);
          mapState.visibilityAutoComplete(false);
          // });

          mapState.destinationControler.text =
              mapState.selectedPlace.toString();
          // mapState.sendRequest(mapState.toString());
          mapState.sendRequest(mapState.destinationControler.text.toString());
          //  mapState.sendRequest(value);
          // print(values[index].code);
          print(mapState.selectedPlace);
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
