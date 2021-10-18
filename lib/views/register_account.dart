import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/shared/loading.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final Database database = Database();

  bool loading = false;
  bool _passwordVisible = true;
  bool _cPasswordVisible = true;

  //form values
  String password = '';
  String email ='';

  String confirmPassword = '';
  String error = '';

  Color errorColor;

  @override
  void initState() {
    _passwordVisible = true;
    _cPasswordVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
            // if loading is true, display loading page, else display screen
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              elevation: 0.0,
              title: Text('Register New Account'),
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
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: textStyleOrange,
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (val) => val.isEmpty ? 'Enter your email address' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        } ); //set contents of text box to password property whenever value is changes
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: textStyleOrange,
                      decoration: textInputDecoration.copyWith(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.white),
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
                      validator: (val) => val.length < 6 ? 'Enter a Password 6+ chars Long' : null,
                      // check if password is valid
                      obscureText: _passwordVisible,
                      onChanged: (val) {
                        setState(() => password =
                            val); //set contents of text box to password property whenever value is changes
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: textStyleOrange,
                      decoration: textInputDecoration.copyWith(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
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
                      validator: (val) => val.length < 6
                          ? 'Enter a Password 6+ chars Long'
                          : null,
                      // check if password is valid
                      obscureText: _cPasswordVisible,
                      onChanged: (val) {
                        setState(() => confirmPassword = val); //set contents of text box to password property whenever value is changes
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: Text(
                          'Register Account',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true); //set loading to true to display loading page on async

                            var result = await database.checkEmail(email);

                            if(result == null){
                              setState(() {
                                error = 'this email is not registered';
                                errorColor = Colors.red;
                                loading = false; //set loading to false to hide loading page
                              });
                            }
                            else if(result.password != '123'){
                              setState(() {
                                errorColor = Colors.red;
                                error = 'this email has already been registered';
                                loading = false;
                              });
                            }
                            else if (password != confirmPassword) {
                              setState(() {
                                error = 'the passwords do not match';
                                errorColor = Colors.red;
                                loading = false; //set loading to false to hide loading page
                              });
                            }
                            else {

                              String res = await database.updatePassword(password, result.clientID);

                              if(res.isNotEmpty){
                                setState(() {
                                  error = 'error registering account';
                                  errorColor = Colors.red;
                                  loading = false; //set loading to false to hide loading page
                                });
                              }
                              else{
                                setState(() {
                                  error = 'Successfully registered account';
                                  errorColor = Colors.green;
                                  loading = false; //set loading to false to hide loading page
                                });
                              }
                            }
                          }
                        }),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: errorColor, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
