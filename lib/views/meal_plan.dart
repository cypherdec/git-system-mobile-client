import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/models/meal_json_model.dart';
import 'package:grit_app/models/meal_plan_model.dart';
import 'package:grit_app/models/recipe_json_model.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/views/display_meal.dart';
import 'package:grit_app/views/display_recipe.dart';
import 'package:intl/intl.dart';

import '../shared/loading.dart';
import 'change_password.dart';
import 'error_page.dart';

class MealPlanPage extends StatefulWidget {  //manage clients accounts and update details

  final MealPlan mealPlan;

  MealPlanPage(this.mealPlan);

  @override
  _MealPlanPageState createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlanPage> {

  MealJson mealJson;
  RecipeJson recipeJson;

  bool isMeal = false;
  bool isNotNull = false;

  void checkNull(){
    try{
      if(widget.mealPlan.mealString != null){
        isNotNull = false;
      }
    }
    catch(e){
      print(e);
      isNotNull = true;
    }
  }



  void getData(){  //convert meal plan json into a model

    recipeJson = recipeJsonFromJson(widget.mealPlan.mealString);
    mealJson = mealJsonFromJson(widget.mealPlan.mealString);

    if(recipeJson.meal1 == null){  //check if json is recipe model or meal model
      setState(() {
        isMeal = true;
      });
    }
    else if(mealJson.carbsAmount1 == null){
      setState(() {
        isMeal = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkNull();
    if(isNotNull == false) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {  //if no plan is available, show error message



    return isNotNull ? Scaffold(
      backgroundColor:  Colors.grey[900],
      body: ErrorPage(),
    )



        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              elevation: 0.0,
              title: Text('Generated on : ${DateFormat('yyyy-MM-dd').format(widget.mealPlan.date)}'),
              titleTextStyle: TextStyle(
                color: Colors.amber,
              ),
            ),
            body: Container(
              // alignment: Alignment.center,
              child: isMeal ? DisplayMeal(mealJson) : DisplayRecipe(recipeJson), //display recipe or meal depending on what is saved for the client
            ),
    );
  }
}
