import 'dart:ffi';

import 'package:flutter/material.dart';

class MapRouteForm extends StatefulWidget {
  MapRouteForm( {this.topLocattion, this. textForm, this.textHint, this.Iconform, this.onChange});

  final double topLocattion;
  final IconData Iconform;
  final String  textForm;
  final String textHint;
  final Function onChange;

  @override
  _MapRouteFormState createState() => _MapRouteFormState();
}

class _MapRouteFormState extends State<MapRouteForm> {
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
          cursorColor: Colors.black,
          // controller: appState.locationController,
          decoration: InputDecoration(
            icon: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              width: 10,
              height: 10,
              child: Icon(
                widget.Iconform,
                color: Colors.black,
              ),
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
