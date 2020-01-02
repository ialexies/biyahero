import 'package:flutter/material.dart';
import 'package:byahero/controllers/helper_design.dart';
import 'package:byahero/widgets/ma_bottom_info_content_destination.dart';
import 'package:byahero/widgets/map_bottom_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/google_maps_request.dart';
import 'package:provider/provider.dart';
import '../states/mapstate.dart';
import 'package:google_sign_in/google_sign_in.dart';


final GoogleSignIn googleSignIn = GoogleSignIn();


class MapScreen extends StatefulWidget {
  // to receive data from the call, constructor 
  static String id='home_screen';

  MapScreen({Key key, this.title}):super(key: key);
  final String title;

  @override
  _MaprouteState createState() => _MaprouteState();
}

class _MaprouteState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),

    );
  }
}

class Map extends StatefulWidget { 
  @override
  _MapState createState() => _MapState();
}
class _MapState extends State<Map> {
 
  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);

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

            ),


          // Positioned(
          //   top: 50.0,
          //   right: 15.0,
          //   left: 15.0,
          //   child: Container(
          //     height: 210.0,
          //     width:500,
          //     // width: double.infinity,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(3.0),
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey,
          //             offset: Offset(1.0, 5.0),
          //             blurRadius: 10,
          //             spreadRadius: 3)
          //       ],
          //     ),
          //     child: Row(
                
          //       children: <Widget>[
          //         Column(children: <Widget>[
          //           Text('data')
          //         ],),
          //         Column(
          //           children: <Widget>[
          //             TextField(
          //               cursorColor: Colors.black,
          //               controller: mapState.locationController,
          //               decoration: InputDecoration(
          //                 icon: Container(
          //                   margin: EdgeInsets.only(left: 20, top: 5),
          //                   width: 10,
          //                   height: 10,
          //                   child: Icon(
          //                     Icons.location_on,
          //                     color: Colors.black,
          //                   ),
          //                 ),
          //                 hintText: "pick up",
          //                 border: InputBorder.none,
          //                 contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          //               ),
          //             ),
          //             TextField(
                    
          //           cursorColor: Colors.black,
          //           controller:  mapState.destinationControler,
          //           textInputAction: TextInputAction.go,
          //           onSubmitted: (value) {
          //             // mapState.autoCompleteContainer = false;
          //             // mapState.autoCompleteContainer = false;
          //             mapState.visibilityAutoComplete(false);
          //             mapState.sendRequest(value);
          //             // mapState.autoCompleteContainer = false;
          //           },
          //           onChanged: (value){
          //             mapState.increment();
          //             // mapState.autoCompleteContainer = true;
          //             if(mapState.destinationControler.text!=null){
          //               mapState.autoCompleteContainer = true;
          //             }else{
          //               mapState.autoCompleteContainer = false;
          //             }
          //           },
          //           decoration: InputDecoration(
          //             suffixIcon: IconButton(
          //               icon: Icon(Icons.delete),
          //               onPressed: (){
          //                 // mapState.destinationControler.text="";
          //                 mapState.clearDestination();
          //                 // GoogleMap
                          
          //               },
          //             ),
          //             icon: Container(
          //               margin: EdgeInsets.only(left: 20, top: 5),
          //               width: 10,
          //               height: 10,
          //               child: Icon(
          //                 Icons.local_taxi,
          //                 color: Colors.black,
          //               ),
          //             ),
          //             hintText: "destination?",
          //             border: InputBorder.none,
          //             contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          //           ),
          //         ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // Positioned(
          //   top: 105.0,
          //   right: 15.0,
          //   left: 15.0,
          //   child: Container(
          //     height: 50.0,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(3.0),
          //       color: Colors.white,
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey,
          //             offset: Offset(1.0, 5.0),
          //             blurRadius: 10,
          //             spreadRadius: 3)
          //       ],
          //     ),
          //     child:
          //      TextField(
                
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

        mapState.destinationControler.text=mapState.selectedPlace.toString();
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

}

