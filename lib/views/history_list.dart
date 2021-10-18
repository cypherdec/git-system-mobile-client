import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:grit_app/views/edit_progress.dart';
import 'package:intl/intl.dart';

class ProgressList extends StatefulWidget {

  final List<Progress> listItems;
  final Function() callback;

  ProgressList(this.listItems, this.callback);  //add list to constructor

  @override
  _ProgressListState createState() => _ProgressListState();
}

class _ProgressListState extends State<ProgressList> {

  Database database = new Database();

  @override
  Widget build(BuildContext context) {

    void _showEditPanel(Progress progress){   //display slide up sheet
      showModalBottomSheet(context: context, isScrollControlled:true, builder: (context){
        return Container(
          color: Colors.grey[800],
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: EditProgressForm(progress, widget.callback),
        );
      });
    }

    return widget.listItems.isEmpty ? Center(child: Text('No Records Available', style: TextStyle(color: Colors.red, fontSize: 30),),) : //error message if no results
    ListView.builder(
      itemCount: widget.listItems.length,  //set length of ist widget to list length
      itemBuilder: (context, index){
        var progress = widget.listItems[index];
        return Card(
          color: Colors.black,
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${DateFormat('yyyy-MM-dd').format(progress.currentDate)}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6.0,),
                        Text(
                          'Weight: ${progress.currentWeight} kg',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.amber[600],
                          ),
                        ),
                        SizedBox(height: 6.0,),
                        Text(
                          'Height: ${progress.currentHeight} cm',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.amber[600],
                          ),
                        ),
                        SizedBox(height: 6.0,),
                        Text(
                          'BMI: ${progress.bmi.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.amber[600],
                          ),
                        ),
                        SizedBox(height: 6.0,),
                        Text(
                          'Rating: ${progress.bmiRating}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.amber[600],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Row(
                children: [
                  IconButton(
                      color: Colors.yellow,
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        _showEditPanel(progress); //show edit form
                      }
                  ),
                  IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        if (await confirm(  //confirmation box for delete
                          context,
                          title: Text('Confirm Delete'),
                          content: Text('are you sure you want to delete progress on this date :  ${DateFormat('yyyy-MM-dd').format(progress.currentDate)} ?'),
                          textOK: Text('Yes'),
                          textCancel: Text('No'),
                        )) {
                          String result =  await database.deleteProgress(progress.progressID);
                          widget.callback();  //execute callback so home page list is updated after item deleted
                        }
                      }
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}