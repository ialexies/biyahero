
import 'package:byahero/states/appstate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id = 'registration_screen';
  final GoogleSignInAccount userInfo;
  final FirebaseUser firebaseUser;
  RegistrationScreen({this.userInfo,this.firebaseUser});

  @override
  _RegistrationScreenState createState() =>
      _RegistrationScreenState(this.userInfo,this.firebaseUser);
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  GoogleSignInAccount userInfo;
  FirebaseUser firebaseUser;
  _RegistrationScreenState(this.userInfo,this.firebaseUser);

  String username;
  String password;
  String contactNumber;
  String address;

  @override
  void initState() {
    super.initState();
    print('hello $userInfo.');
  }

  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      _formKey.currentState.save(); //save the content of the form
      SnackBar snackBar = SnackBar(
        content: Text("Welcome $username!"),
      ); //define a snackbar content
      _scaffoldKey.currentState.showSnackBar(snackBar); //show snackbar
      Navigator.pop(context, [username, contactNumber, address]);
    }
  }

  @override
  Widget build(BuildContext parentContext) {

    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              userInfo!=null? Column(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(userInfo.photoUrl),
                          fit: BoxFit.cover),
                      borderRadius: new BorderRadius.all(Radius.circular(75)),
                      border: Border.all(color: Colors.grey[400], width: 5),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      // userInfo.displayName.toUpperCase(),
                  '',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 5),
                  //   child: Text(
                  //     firebaseUser.toString(),
                  //     style: TextStyle(fontSize: 15),
                  //   ),
                  // ),
                ],
              ):Text(''),
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
                        
                        firebaseUser.phoneNumber!=null?
                          Text( 
                            firebaseUser.phoneNumber,
                            style: TextStyle(fontSize: 30),
                            )
                          :Text(''),
                        SizedBox(height: 30,),
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
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Enter User Name",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
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
                          onSaved: (val) => password = val,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(fontSize: 15),
                            hintText: "Enter a password",
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          initialValue: firebaseUser.phoneNumber!=null?    firebaseUser.phoneNumber.toString().replaceAll('+63', '0'):null,
                          enabled: firebaseUser.phoneNumber==null?true:false,
                          validator: (valcontact) {
                            if (valcontact.trim().length < 8 ||
                                valcontact.isEmpty) {
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
                          onSaved: (valContact) => contactNumber = valContact,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 15),
                              hintText: "Contact No."),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (valAddress) {
                            if (valAddress.trim().length < 10 ||
                                valAddress.isEmpty) {
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
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(fontSize: 15),
                              hintText: "Home Address"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
