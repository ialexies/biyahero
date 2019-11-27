import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateAccount extends StatefulWidget {
  final GoogleSignInAccount userInfo;
  CreateAccount({this.userInfo});

  @override
  _CreateAccountState createState() => _CreateAccountState(this.userInfo);
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  GoogleSignInAccount userInfo;
  _CreateAccountState(this.userInfo);

  String username;
  String contactNumber;
  String address;

  @override
  void initState() {
    super.initState();
    print('hello $userInfo.');
  }

  submit() {
    print('----$username');
    print('----$contactNumber');
    print('----$address');

    final form = _formKey.currentState;
    if (form.validate()) {
      _formKey.currentState.save(); //save the content of the form
      SnackBar snackBar = SnackBar(
        content: Text("Welcome $username!"),
      ); //define a snackbar content
      _scaffoldKey.currentState.showSnackBar(snackBar); //show snackbar
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context, [username,contactNumber,address]);
      }); //redirect back to home after 2 seconds
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:
          header(context, titleText: 'Setup Profile', removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
        
              SizedBox(height: 30,),
              Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(userInfo.photoUrl),fit: BoxFit.cover),
                      borderRadius: new BorderRadius.all(Radius.circular(75)),
                      border: Border.all(color: Colors.grey[400], width: 5),

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text(userInfo.displayName.toUpperCase(), style: TextStyle(
                      fontSize:25,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(userInfo.email, style: TextStyle(
                      fontSize:15
                    ),),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  child: Form(
                    //
                    key: _formKey,
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
                          },
                          onSaved: (val) => username = val,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Enter User Name",
                          ),
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
                        
                      ],
                    ),
                  ),
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
                      borderRadius: BorderRadius.circular(7.0)),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
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
