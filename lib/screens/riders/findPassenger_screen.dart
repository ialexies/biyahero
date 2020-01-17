import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/header.dart';
import '../../controllers/helper_google_account.dart';

  Firestore _firestore = Firestore.instance;
  

final transactionsRef = Firestore.instance.collection('transactions');
List<String> waitingPassengers = [];

class FindPassengerScreeen extends StatefulWidget {
  @override
  FindPassengerScreeenState createState() => FindPassengerScreeenState();
}

class FindPassengerScreeenState extends State<FindPassengerScreeen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

 
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appHeader(context,
          titleText: 'Find Passenger', removeBackButton: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: transactionsRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final List<Container> children =
              // snapshot.data.documents.map((doc) => Text(doc['uid'])).toList();
              snapshot.data.documents.map((doc) => Container(
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.album),
                        title:Text(doc['uid']),
                      )
                    ],
                  ),
                ),
              )).toList();
              
          return ListView(
            children: children,
          );
        },
      ),
    );
  }
}
