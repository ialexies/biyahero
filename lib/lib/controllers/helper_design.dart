// import 'package:awesome_button/awesome_button.dart';
import 'package:flutter/material.dart';

Size appScreenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double appScreenHeight(BuildContext context, {double dividedBy = 1}) {
  return appScreenSize(context).height / dividedBy;
}

double appsScreenWidth(BuildContext context, {double dividedBy = 1}) {
  return appScreenSize(context).width / dividedBy;
}


 linearProgress() {
	  return Container(
	    padding: EdgeInsets.only(bottom: 10),
	    child: LinearProgressIndicator(
	      valueColor: AlwaysStoppedAnimation(Colors.purple),
	    ),
	  );
	}


