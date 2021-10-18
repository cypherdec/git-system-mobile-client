import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:intl/intl.dart';

import 'history_list.dart';

class ProgressHistory extends StatefulWidget {
  final List<Progress> listItems;
  final Function() callback;

  ProgressHistory(this.listItems, this.callback);
  @override
  _ProgressHistoryState createState() => _ProgressHistoryState();
}

class _ProgressHistoryState extends State<ProgressHistory> {

  Database database = new Database();

  List<Progress> widgetList = [];

  List<Progress> progressList = [];
  String endDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String startDateString = "";
  DateTime startDate;
  DateTime endDate = DateTime.now();


  @override
  void initState(){   //load employee list on page load
    super.initState();
    widgetList = widget.listItems;
    progressList = widget.listItems;
  }

  updateRecords() async {
    widget.callback();

    widgetList = await database.getProgressList(widget.listItems.last.clientID);
    setState(() {
      progressList = widgetList;
    });
    onFilterChanged();
  }

  onFilterChanged() {

    if(startDate != null && endDate !=null ) { //avoid null value errors
      List<Progress> filterList = []; //empty list to hold filtered values

      for (Progress progress in widgetList ){ //filter widget list with date criteria
        if (progress.currentDate.toLocal().isBefore(endDate) && progress.currentDate.toLocal().isAfter(startDate)){
          filterList.add(progress); //add filtered values to new list
       }
      }
      progressList = filterList; //set progresslist that goes to list builder to filtered list
    }
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      child:  Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Progress History - ${widgetList.length.toString()} Records'),
          backgroundColor: Colors.grey[900],
          elevation: 0.0,
          actions: [

          ],
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.black, // background
                        onPrimary: Colors.black, // foreground
                        side: BorderSide(
                          width: 2.0,
                          color: Colors.orange,
                        ),
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,   //show date picket widget
                            showTitleActions: true,
                            minTime: DateTime(2018, 1, 1),
                            theme: DatePickerTheme(
                                headerColor: Colors.orange,
                                backgroundColor: Colors.black,
                                itemStyle: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle:
                                TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                startDateString = DateFormat('yyyy-MM-dd').format(date);
                                startDate = date;
                                onFilterChanged(); //update filter
                              }); //format date
                            },
                            currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'Start Date : $startDateString',
                        style: TextStyle(color: Colors.amber),
                      )
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.black, // background
                        onPrimary: Colors.black, // foreground
                        side: BorderSide(
                          width: 2.0,
                          color: Colors.orange,
                        ),
                      ),
                      onPressed: () {
                        DatePicker.showDatePicker(context,   //show date picket widget
                            showTitleActions: true,
                            minTime: DateTime(2018, 1, 1),
                            theme: DatePickerTheme(
                                headerColor: Colors.orange,
                                backgroundColor: Colors.black,
                                itemStyle: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle:
                                TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)
                            ),
                            onChanged: (date) {
                            }, onConfirm: (date) {
                              setState(() {
                                endDateString = DateFormat('yyyy-MM-dd').format(date);
                                endDate = date;
                                onFilterChanged();
                              }); //format date
                            },
                            currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: Text(
                        'End Date : $endDateString',
                        style: TextStyle(color: Colors.amber),
                      )
                  ),
                ),
              ],
            ),
             SizedBox(height: 5,),
             Text(
               'Filtered Records ${progressList.length}',
               style: TextStyle(
                 fontSize: 15,
                 color: Colors.white,
               ),
             ),
            SizedBox(height: 5,),
             Expanded(
              child: ProgressList(progressList.reversed.toList(), updateRecords),
            )
          ],
        ),
      ),
    );
  }
}
