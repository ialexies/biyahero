import 'dart:ffi';

import 'package:flutter/material.dart';
import '../pages/map_route.dart';

class MapRouteForm extends StatefulWidget {
  MapRouteForm( {this.topLocattion, this. textForm, this.textHint, this.Iconform, this.onChange, this.frmPickupController });

  final double topLocattion;
  final IconData Iconform;
  final String  textForm;
  final String textHint;
  final Function onChange;
   TextEditingController frmPickupController;
  // TextEditingController destinationController = TextEditingController();

  @override
  _MapRouteFormState createState() => _MapRouteFormState();
}

class _MapRouteFormState extends State<MapRouteForm> {
  // TextEditingController frmPickupController;
  // TextEditingController statefrmPickupController;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.topLocattion,
      right: 15.0,
      left: 15.0,
      child: Container(
        height: 50.0,
        width: double.infinity,
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
        child: TextField(
          
          controller: widget.frmPickupController,
          onChanged: widget.onChange,
          cursorColor: Colors.black,
          // controller: appState.locationController,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: Icon(widget.Iconform),
              color: Colors.black87,
              onPressed: (){print('pressssssssssssssed');},
            ),
            
         
            hintText: widget.textHint,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          ),
        ),
      ),
    );
  }
}
