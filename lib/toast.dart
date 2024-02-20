import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void toast(msg){
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0
  );
}