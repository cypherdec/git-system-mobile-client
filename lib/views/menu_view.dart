import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:grit_app/views/progress_history.dart';

import 'account.dart';

class Menu extends StatefulWidget {

  final Client client;
  final List<Progress> progressList;
  final Function() callback;

  Menu(this.client, this.progressList, this.callback);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 150,),
            Text('Menu', style: TextStyle(fontSize: 40.0),),
            SizedBox(height: 30,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.black),
                ),
                icon: Icon(Icons.person),
                label: Text('Account'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageAccount(widget.client), //send client model and progress list to home page
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.black),
                ),
                icon: Icon(Icons.update),
                label: Text('History'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgressHistory(widget.progressList, widget.callback), //send client model and progress list to history page
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.black),
                ),
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                onPressed: () {
                  Navigator.pushReplacementNamed(context,
                      '/'); //go to sign in screen and replace this one so cant go back
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}

