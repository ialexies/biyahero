import 'package:flutter/material.dart';
import 'package:fluttershare/states/mapstate.dart';
import 'package:provider/provider.dart';

Positioned mapBottomInfo(
    {context, screeWidth, Widget content, var1, var2, var3}) {
  return Positioned(
    bottom: 0,
    // height: 60,
    width: screeWidth / 2,
    child: Visibility(
      // visible: var1,
      // visible: MapState().destinationBottomInfo,
      // final mapState = Provider.of<MapState>(context);
      visible: Provider.of<MapState>(context).destinationBottomInfo,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.black.withOpacity(.5),
          child: Column(
            children: <Widget>[
              content,
              RaisedButton(
                elevation: 30,
                onPressed: () {},
                textColor: Colors.black,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.cyanAccent,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Available Drivers',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 5,)
            ],
          ),
        ),
      ),
    ),
  );
}
