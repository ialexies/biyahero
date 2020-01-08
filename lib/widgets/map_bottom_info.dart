// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:byahero/states/mapstate.dart';
import 'package:provider/provider.dart';

Positioned mapBottomInfo({context,screeWidth,Widget content, var1, var2, var3}){
  return 
    Positioned  (
      bottom: 0,
      // height: 60,
      // width: screeWidth/7,
      child: Visibility(
        // visible: var1, 
        // visible: MapState().destinationBottomInfo, 
        // final mapState = Provider.of<MapState>(context);
        visible: Provider.of<MapState>(context).destinationBottomInfo  ,
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                color: Colors.black.withOpacity(.6),
                child: content,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: FloatingActionButton(
                  elevation: 30,
                  onPressed: (){
                    _showDialog(context: context);
                  },
                  child: Icon(Icons.drive_eta),
                ),
              )

            ],
          ),
        ),
      ),
    );
}

 void _showDialog({context}) {
   
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("List of Available Drivers"),
          content:Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text('Alexies Iglesia'),
                Text('Alexies Iglesia'),
                Text('Alexies Iglesia'),
                Text('Alexies Iglesia'),
              ],
            ),
          ),

          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }