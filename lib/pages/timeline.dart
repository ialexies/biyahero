import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';


final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    // getUserById();
  
  }

  // getUsers() async{
  //   final QuerySnapshot snapshot = await usersRef.where("isAdmin", isEqualTo: true).getDocuments();
  //   snapshot.documents.forEach((doc){
  //     print(doc.data);
  //   });
  // }


  // getUsers() async{
  //   final QuerySnapshot snapshot = await usersRef
  //     .where("postCount",isLessThan: 6)
  //     .where("username", isEqualTo: "Alex")
  //     .getDocuments();

  //     snapshot.documents.forEach((DocumentSnapshot doc){
  //       print(doc.data);
  //     });
  // }
  getUsers() async{
    final QuerySnapshot snapshot = await usersRef
      .limit(2)
      .getDocuments();

      snapshot.documents.forEach((DocumentSnapshot doc){
        print(doc.data);
      });
  }

  // getUsers() async{
  //   final QuerySnapshot snapshot = 
  //   await usersRef.where("postCount", isGreaterThan: 2)
  //   .getDocuments();

  //   snapshot.documents.forEach((DocumentSnapshot doc){
  //     print(doc.data); 
  //   });
  // }



  // getUserById(){
  //   final String  id= 'ftOdrqBpYYXv5VXS9O6d';
  //   usersRef.document(id).get().then((DocumentSnapshot doc){
  //      print(doc.data);
  //       print(doc.documentID);
  //       print(doc.exists);
  //   });
  // }

  // getUserById() async{
  //   final String  id= 'ftOdrqBpYYXv5VXS9O6d';
  //   final DocumentSnapshot doc = await usersRef.document(id).get();
  //     print(doc.data);
  //     print(doc.documentID);
  //     print(doc.exists);
  // }

  // getUsers(){
  //   usersRef.getDocuments().then((QuerySnapshot snapshot){
  //     snapshot.documents.forEach(( DocumentSnapshot doc){
        // print(doc.data);
        // print(doc.documentID);
        // print(doc.exists);
  //     });
  //   });
  // }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      // body: circularProgress(),
      body: linearProgress(),
    );
  }
}
