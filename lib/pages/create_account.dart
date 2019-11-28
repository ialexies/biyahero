import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';



class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey =  GlobalKey<FormState>();

  String username;
  
  submit(){
    final form = _formKey.currentState;
    if (form.validate()){
      _formKey.currentState.save();  //save the content of the form
      SnackBar snackBar = SnackBar(content: Text("Welcome $username!"),); //define a snackbar content
      _scaffoldKey.currentState.showSnackBar(snackBar); //show snackbar
      Timer(Duration(seconds: 2), (){Navigator.pop(context, username);}); //redirect back to home after 2 seconds
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: 'Setup Profile', removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
                padding: EdgeInsets.only(top: 25),
                child: Center(
                  child:
                      Text("Create username", style: TextStyle(fontSize: 25)),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Form(
                    // 
                    key: _formKey,
<<<<<<< HEAD
                    autovalidate:
                        true, //If set to true, it immediately validates the input every type of user
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (val) {
                            if (val.trim().length < 3 || val.isEmpty) {
                              return 'Usarneme too short';
                            } else if (val.trim().length > 12) {
                              return 'Username too long';
                            } else if (val.trim() == null) {
                              return 'Please enter a Username';
                            } else {
                              return null;
                            }
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          
                          validator: (valcontact) {
                            if (valcontact.trim().length < 8 || valcontact.isEmpty) {
                              return 'Contact No. is too short';
                            } else if (valcontact.trim().length > 12) {
                              return 'Username too long';
                            } else if (valcontact.trim() == null) {
                              return 'Please enter Contact No.';
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.number,
                          onSaved: (valContact)=> contactNumber = valContact,
                          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.contact_phone),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Contact No."),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          validator: (valAddress) {
                            if (valAddress.trim().length < 10 || valAddress.isEmpty) {
                              return 'Your Home Address is too short';
                            } else if (valAddress.trim().length > 50) {
                              return 'Address is too long';
                            } else if (valAddress.trim() == null) {
                              return 'Please enter your address';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (valAddress) => address = valAddress,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            prefixIcon: Icon(Icons.markunread_mailbox),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Home Address"),
                        ),
                        SizedBox(height: 10,),
=======
                    autovalidate: true, //If set to true, it immediately validates the input every type of user
                    child: TextFormField(
                      validator: (val){
                        if (val.trim().length<3||val.isEmpty){
                          return 'usarneme too short';
                        } else if (val.trim().length>12 ){
                          return 'username too long';
                        } else{
                          return null;
                        }
>>>>>>> parent of c45cc38... finish user profile input with validation and firestore
                        
                      },
                      onSaved: (val)=> username = val ,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(fontSize: 15),
                        hintText: "At least 3 characters", 
                      ),
                    ),),
                ),
              ),
              GestureDetector(
                onTap: submit,
                child: Container(
                  height: 70,
                  width: 350,
                  padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(7.0)
                  ),
                  child: Center(
                    child: Text("Submit", style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
