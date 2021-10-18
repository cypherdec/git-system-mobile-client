import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/chart_data_mode.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/models/meal_json_model.dart';
import 'package:grit_app/models/meal_plan_model.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:grit_app/models/recipe_json_model.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/views/chart_widget.dart';
import 'package:grit_app/views/update_progress_form.dart';
import 'package:intl/intl.dart';
import 'meal_plan.dart';
import 'menu_view.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final Client client;
  final List<Progress> progressList; //get list of progresses and client model from sign in screen

  Home(this.client, this.progressList);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> filterStrings = [
    '3 Months',
    '6 Months',
    '12 Months',
    'All'
  ];

  Database database = new Database();
  bool loading = false;
  String filterVal = 'All';

  List<Progress> progressList = [];

  List<ChartData> chartDataList = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void convertData(List<Progress> progressList, String filter) {
    //convert list of progresses into data series list for chart display
    chartDataList.clear();
    int monthsPast = filterData(filter);

    DateTime today = DateTime.now();
    Duration d = new Duration(days: 30 * monthsPast);
    DateTime past = today.subtract(d); //date to be filtered by

    for (Progress p in progressList) {
      String date = DateFormat('dd-MM-yyyy').format(p.currentDate).toString();
      int weight = p.currentWeight;

      ChartData chartData = new ChartData(weight, date);

      if (monthsPast == 0) {
        // display all results
        chartDataList.add(chartData);
      } else if (p.currentDate.isAfter(past)) {
        //display filtered results
        chartDataList.add(chartData);
      }
    }
  }

  updateRecords() async {
    List<Progress> newList = [];
    newList = await database.getProgressList(widget.client.clientID);
    progressList = newList;

    convertData(newList, 'All');
  }

  int filterData(String filter) {
    //get selected months difference from drop down selection
    int dateChange;
    if (filter == '3 Months') {
      dateChange = 3;
    }
    if (filter == '6 Months') {
      dateChange = 6;
    }
    if (filter == '12 Months') {
      dateChange = 12;
    }
    if (filter == 'All') {
      dateChange = 0;
    }
    return dateChange;
  }

  void showUpdateForm(Progress progress) {
    //display slide up sheet
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            color: Colors.grey[900],
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: UpdateProgressForm(progress), //show update progress form
          );
        }).then((value) {
      setState(() {
        if (value != null) { //if updated list is received
          progressList = value['proList'];
          convertData(value['proList'],
              filterVal); //get updated progress list and refresh chart
        }
      });
    });
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('No meal plan generated. please contact your coach ', style: TextStyle(color: Colors.red),),
      ),
    );
  }

  final _drawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();
    progressList = widget.progressList;
    convertData(progressList, 'All');
  }

  @override
  Widget build(BuildContext context) {
    return  ZoomDrawer(
      controller: _drawerController,
      style: DrawerStyle.Style1,
      borderRadius: 24.0,
      showShadow: true,
      angle: -10.0,
      backgroundColor: Colors.grey[300],
      slideWidth: MediaQuery.of(context).size.width *
          (ZoomDrawer.isRTL() ? .25 : 0.45),

      menuScreen: Menu(widget.client, progressList, updateRecords),

      mainScreen: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.blue[900],
            ),
            onPressed: () => _drawerController.toggle(),
          ),
          title: Text('Progress Manager'),
          backgroundColor: Colors.grey[900],
          elevation: 5.0,
          actions: [

          ],
        ),
        body: Column(
            children: [
              SizedBox(height: 10,),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: DropdownButtonFormField(
                    decoration: textInputDecoration.copyWith(
                        labelText: 'Filter Results',
                        labelStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(
                      color: Colors.amber,
                      backgroundColor: Colors.black,
                      decorationColor: Colors.black,
                    ),
                    value: filterVal,
                    items: filterStrings.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text('$filter'),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        filterVal = value;
                        convertData(progressList, filterVal);
                      });
                    }),
              ),
              SizedBox(height: 10,),
              Text(
                'Coach : ' + widget.client.coach, //current bmi and rating from database
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'BMI - ' + progressList.last.bmi.toStringAsFixed(2) + ' : ' + progressList.last.bmiRating, //current bmi and rating from database
                style: TextStyle(
                  color: Colors.amber,
                ),
              ),
              Expanded(
                child: ProgressChart( chartDataList, progressList.last.trainingGoal), //display progress details chart. send chartDataList and current training goal to ProgressChart widget)
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.grey[800], // background
                        onPrimary: Colors.white, // foreground
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.amber,
                        ),
                      ),
                      icon: Icon(Icons.style),
                      label: Text('Meal Plan'),
                      onPressed: () async {
                        Database database = new Database();

                        setState(() {
                          loading = true;
                        });

                        MealPlan mealPlan =await database.getMealPlan(widget.client.clientID);  //custom plan

                       // MealPlan mealPlan =await database.getMealPlan(51); //recipe

                      //  MealPlan mealPlan =await database.getMealPlan(59); //no meal plan


                        setState(() {
                          loading = false;
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MealPlanPage(mealPlan) //send meal plan object to wrapper
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.grey[800], // background
                        onPrimary: Colors.white, // foreground
                        side: BorderSide(
                          width: 1.0,
                          color: Colors.amber,
                        ),
                      ),
                      icon: Icon(Icons.add),
                      label: Text('Update'),
                      onPressed: () {
                        Progress old = progressList.last;
                        showUpdateForm(old);
                      },
                    ),
                  ),
                ],
              )
            ],
        ),
      ),
    );
  }
}
