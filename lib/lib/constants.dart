import 'package:flutter/material.dart';


const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  // hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);



const kBodyPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);
const kContainerRegularPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);
const kFormSubmitButtonDecoration = BoxDecoration(
  //  borderRadius: BorderRadius.all(Radius.circular(32.0)),
  // borderRadius: BorderRadius.circular(),
  color: Colors.blue,
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),

  ),
  // borderRadius: BorderRadius.all(Radius.circular(5.0)),

);
const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kTextHeading1 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold
  
);
