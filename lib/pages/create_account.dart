import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
 final _formKey =  GlobalKey<FormState>();
 submit(){
   _formKey.currentState.save();
   Navigator.pop(context, username);
 }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, titleText: 'Setup Profile'),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
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
                    child: TextFormField(
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
