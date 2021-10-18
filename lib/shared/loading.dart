import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {   //display loading screen widget while async functions load
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,  //background color
      child: Center(
        child: SpinKitCubeGrid(  //loading animation type
          color: Colors.amber, //animation color
          size: 50.0,
        ),
      ),
    );
  }
}
