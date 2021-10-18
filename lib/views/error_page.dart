import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Error'),
        titleTextStyle: TextStyle(color: Colors.red),
      ),
      body: Center(
        child:  Container(color: Colors.grey[900],
          child: Text('No meal plan generated. please contact your coach', style: TextStyle(color: Colors.red, fontSize: 30),)
          ,),
      ),
    );
}
}
