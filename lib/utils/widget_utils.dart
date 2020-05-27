import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSnackBar(
  GlobalKey<ScaffoldState> scaffoldKey,
  String message, [
  int duration = 1,
]) {
  scaffoldKey.currentState.showSnackBar(
    new SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    ),
  );
}
