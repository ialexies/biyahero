import 'package:flutter/material.dart';

Positioned mapBottomInfo({context,screeWidth,Widget content, var1, var2, var3}){
  return 
          Positioned  (
            bottom: 0,
            // height: 60,
            width: screeWidth,
            child: Visibility(
              visible: var1, 
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.black.withOpacity(.4),
                  child: content,
                ),
              ),
            ),
          );
}