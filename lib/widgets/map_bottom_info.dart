import 'package:flutter/material.dart';
import 'package:byahero/states/mapstate.dart';
import 'package:provider/provider.dart';

Positioned mapBottomInfo({context,screeWidth,Widget content, var1, var2, var3}){
  return 
    Positioned  (
      bottom: 0,
      // height: 60,
      width: screeWidth/3,
      child: Visibility(
        // visible: var1, 
        // visible: MapState().destinationBottomInfo, 
        // final mapState = Provider.of<MapState>(context);
        visible: Provider.of<MapState>(context).destinationBottomInfo  ,
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.black.withOpacity(.6),
            child: content,
          ),
        ),
      ),
    );
}