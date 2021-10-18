import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(  //shared style for text fields, labelText is not defined here so will be defined at point of use
  fillColor: Colors.black,
  filled: true,
  hintStyle: TextStyle(
    color: Colors.white,
  ),
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0)
  ),
);


const textStyleOrange = TextStyle(  //default text style, used all over app
  color: Colors.amber,
);

