import 'package:flutter/material.dart';
import 'package:grit_app/views/sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SignIn(),
      }
  ));
}



