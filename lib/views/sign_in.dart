import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/views/home.dart';
import 'package:grit_app/views/register_account.dart';
import '../shared/loading.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

 // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();  //create global key to track form and help validate
  final Database database = Database();

  //text field state
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool _passwordVisible = true;

  List<Progress> progressList = [];

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold( // if loading is true, display loading page, else display screen
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        title: Text('Grit Progress Manager'),
        titleTextStyle: TextStyle(
        color: Colors.amber,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                  'assets/3dlogo.jpg',
                  width: 500.0,
                  fit:BoxFit.fitWidth
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: textStyleOrange,
                decoration: textInputDecoration.copyWith(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (val) => val.isEmpty ? 'Enter an Email' : null, //ternary operator checks to see if field is empty
                onChanged: (val){  //function runs every time value changes in text form
                  setState(() => email = val);  //set contents of text box to email property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: textStyleOrange,
                decoration: textInputDecoration.copyWith(labelText: 'Password', labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.blue[900],
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (val) => val.length < 6 ? 'Enter a Password 6+ chars Long' : null,  // check if password is valid
                obscureText: _passwordVisible,
                onChanged: (val){
                  setState(() => password = val); //set contents of text box to password property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all<Color>(Colors.amber[400]),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {

                    if(_formKey.currentState.validate()){   //validate form in current state as button is clicked, returns bool value

                      setState(() => loading = true);  //set loading to true to display loading page on async

                      Client client = await database.login(email, password);

                      if(client == null){
                        setState(() {
                          error = 'could not sign in with provided credentials';
                          loading = false;  //set loading to false to hide loading page
                        });
                      }
                      else{
                        List<Progress> proList = await database.getProgressList(client.clientID);  //generate list of progresses for client

                        setState((){
                          error = '';
                          loading = false;  //set loading to false to hide loading page

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(client, proList),  //send client model and progress list to home page
                            ),
                          );

                        });
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.redAccent, fontSize: 14.0),
              ),
              SizedBox(height: 12.0),
              Container(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Text(
                    'New Account?',
                    style: TextStyle(
                      color: Colors.blue[600],
                    ),
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationForm(),  //send client model and progress list to home page
                      ),
                    );
                  },
                )
              )
            ],
          ),
        ),
      ),

    );
  }
}
