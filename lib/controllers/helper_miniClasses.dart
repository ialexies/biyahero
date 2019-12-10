import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CodeGenerators {
  generateUUID() {
    var uuid = new Uuid();
    String controlCode = uuid.v1().toString();
    return controlCode;
  }
}
