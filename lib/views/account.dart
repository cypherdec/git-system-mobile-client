import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/shared/constants.dart';

import '../shared/loading.dart';
import 'change_password.dart';

class ManageAccount extends StatefulWidget {  //manage clients accounts and update details

  final Client client;

  ManageAccount(this.client);

  @override
  _ManageAccountState createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {

  final _formKey = GlobalKey<FormState>();  //create global key to track form and help validate
  final Database database = Database();

  String firstName = '';
  String lastName = '';
  String tele = '';
  String email = '';

  TextStyle errorStyle = new TextStyle();

  String error = '';
  bool loading = false;

  @override
  void initState() {
    firstName = widget.client.firstName;
    lastName = widget.client.lastName;
    tele = widget.client.tele;
    email = widget.client.email;

    super.initState();
  }

  void showChangePasswordPanel(){   //display slide up sheet
    showModalBottomSheet(context: context, isScrollControlled:true, builder: (context){
      return Container(
        color: Colors.grey[900],
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
        child: ChangePasswordForm(widget.client.clientID), //show change password form
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold( // if loading is true, display loading page, else display screen
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        title: Text('Manage Account'),
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
              TextFormField(
                style: textStyleOrange,
                initialValue: firstName,
                decoration: textInputDecoration.copyWith(labelText: 'First Name', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter First Name' : null, //ternary operator checks to see if field is empty
                onChanged: (val){  //function runs every time value changes in text form
                  setState(() => firstName = val);  //set contents of text box to firstName property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: textStyleOrange,
                initialValue: lastName,
                decoration: textInputDecoration.copyWith(labelText: 'Last Name', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter Last Name' : null, //ternary operator checks to see if field is empty
                onChanged: (val){  //function runs every time value changes in text form
                  setState(() => lastName = val);  //set contents of text box to lastName property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                style: textStyleOrange,
                initialValue: tele,
                decoration: textInputDecoration.copyWith(labelText: 'Telephone', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter Telephone' : null, //ternary operator checks to see if field is empty
                onChanged: (val){  //function runs every time value changes in text form
                  setState(() => tele = val);  //set contents of text box to tele property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),TextFormField(
                style: textStyleOrange,
                initialValue: email,
                decoration: textInputDecoration.copyWith(labelText: 'Email', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter an Email' : null, //ternary operator checks to see if field is empty
                onChanged: (val){  //function runs every time value changes in text form
                  setState(() => email = val);  //set contents of text box to email property whenever value is changes
                },
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {

                    if(_formKey.currentState.validate()){   //validate form in current state as button is clicked, returns bool value
                      setState(() => loading = true);  //set loading to true to display loading page on async

                      Client client = new Client(widget.client.clientID, firstName, lastName, widget.client.gender, tele, widget.client.dob, email, widget.client.password, "");

                      var result = await database.updateAccount(client);

                      if(result.isNotEmpty){
                        setState(() {
                          errorStyle = TextStyle(color: Colors.redAccent, fontSize: 14.0);
                          error = 'something went wrong : ' + result;
                          loading = false;  //set loading to false to hide loading page
                        });
                      }else{
                        setState((){
                          errorStyle = TextStyle(color: Colors.green, fontSize: 14.0);
                          error = 'Successfully updated';
                          loading = false;  //set loading to false to hide loading page
                        });
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: errorStyle,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showChangePasswordPanel();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
