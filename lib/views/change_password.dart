import 'package:flutter/material.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/shared/loading.dart';

class ChangePasswordForm extends StatefulWidget {

  final int clientID;

  ChangePasswordForm(this.clientID);

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {

  final _formKey  = GlobalKey<FormState>();
  final Database database = Database();

  bool loading = false;
  bool _passwordVisible = true;
  bool _cPasswordVisible = true;

  //form values
  String password ;
  String confirmPassword;
  String error ='' ;
  Color errorColor;

  @override
  void initState() {
    _passwordVisible = true;
    _cPasswordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return loading ? Loading() :  Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text(
              'Change Password',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              style: textStyleOrange,
              decoration: textInputDecoration.copyWith(labelText: 'New Password', labelStyle: TextStyle(color: Colors.white),
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
            TextFormField(
              style: textStyleOrange,
              decoration: textInputDecoration.copyWith(labelText: 'Confirm Password', labelStyle: TextStyle(color: Colors.white), suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _cPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.blue[900],
                ),
                onPressed: () {
                  setState(() {
                    _cPasswordVisible = !_cPasswordVisible;
                  });
                },
              ),
              ),
              validator: (val) => val.length < 6 ? 'Enter a Password 6+ chars Long' : null,  // check if password is valid
              obscureText: _cPasswordVisible,
              onChanged: (val){
                setState(() => confirmPassword = val); //set contents of text box to password property whenever value is changes
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text(
                  'Update Password',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {

                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true); //set loading to true to display loading page on async



                    if (password != confirmPassword ) {
                      setState(() {
                        error = 'the passwords do not match';
                        errorColor = Colors.red;
                        loading = false; //set loading to false to hide loading page
                      });
                    }
                    else{

                      String result = await database.updatePassword(password, widget.clientID);

                      if(result.isNotEmpty){
                        setState(() {
                          error = 'error changing password';
                          errorColor = Colors.red;
                          loading = false; //set loading to false to hide loading page
                        });
                      }
                      else{
                        setState(() {
                          error = 'Successfully changed password';
                          errorColor = Colors.green;
                          loading = false; //set loading to false to hide loading page
                        });
                      }
                    }
                  }
                }
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: errorColor, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
