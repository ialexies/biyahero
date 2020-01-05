import 'package:byahero/states/mapstate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 LocationSearchView({contex,snapshot}){
  // AsyncSnapshot snapshot;
  // BuildContext context;
  // LocationSearchView(context,this.snapshot);
  
 
  Widget build(BuildContext context) {
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

        mapState.textDestinationControler.text=mapState.selectedPlace.toString();
        // mapState.sendRequest(mapState.toString());
        mapState.sendRequest(mapState.textDestinationControler.text.toString());
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