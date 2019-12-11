import 'package:flutter/material.dart';
import 'package:fluttershare/states/appstate.dart';
import 'package:fluttershare/states/mapstate.dart';
import 'package:provider/provider.dart';

Widget destinationBottomInfoContent({context, destinationkm, detinationDuration}) {
  final mapState = Provider.of<MapState>(context);
  
  double totalPrice =   ((destinationkm-1)*mapState.getregPriceKm())+mapState.getminimumPrice() ;
  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Text(
              'P$totalPrice for your ${destinationkm.toString()}Km destination. \nIt will take you $detinationDuration for you \nto arrive at your destination. ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            // Text(
            //   appState.minimumPrice.toString(),
            // )
         
          ],
        ),
      ),

      // Text('${mapsta} to your destination ',textAlign: TextAlign.right,),
    ],
  );
}
