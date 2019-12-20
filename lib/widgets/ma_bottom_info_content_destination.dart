import 'package:flutter/material.dart';
import 'package:fluttershare/states/appstate.dart';
import 'package:fluttershare/states/mapstate.dart';
import 'package:provider/provider.dart';

Widget destinationBottomInfoContent({context, destinationkm, detinationDuration}) {
  final mapState = Provider.of<MapState>(context);
  
  
  double totalPrice =   ((destinationkm-1)*mapState.getregPriceKm())+mapState.getminimumPrice() ;
  totalPrice = totalPrice.roundToDouble();

  return Column(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Text(
              'Price:  P$totalPrice \nPrice:  ${destinationkm.toString()}Km \nDuration:  $detinationDuration ',
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.white, fontSize: 16),
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
