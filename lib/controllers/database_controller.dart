import 'package:flutter/material.dart';
import 'package:grit_app/models/client_model.dart';
import 'package:grit_app/models/meal_plan_model.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:mysql1/mysql1.dart';

class Database{
  var connection = new ConnectionSettings(  //mysql server connection settings
      host: '10.0.2.2',
      port: 3306,
      user: 'root',
      password: 'password',
      db: 'gritappdb',
  );

  Future<Client> login (String email, password ) async {  //checks database for email and password to check for match and login
    var conn = await MySqlConnection.connect(connection);
    Client client;
   var result = await conn.query('SELECT * from dbClients WHERE Email = ? AND Password = ?', [email, password]);  //execute sql query

    if(result.isEmpty){  //check to see if login is valid
      print('no data');
    }
    else{
      for (var row in result){
        client = toClient(row);   //convert sql record to client object
      }
    }

    await conn.close();

    return client;
    
  }

  Future<Client> checkEmail (String email ) async {  //checks database for email to check for if valid
    var conn = await MySqlConnection.connect(connection);
    Client client;
    var result = await conn.query('SELECT * from dbClients WHERE Email = ?', [email]);

    if(result.isEmpty){
      print('no data');
    }
    else{
      for (var row in result){
        client = toClient(row);  //convert sql record to client object
      }
    }

    await conn.close();

    return client;

  }

  Future<List<Progress>> getProgressList(int id) async {  //gets list of progresses for logged in client
    var conn = await MySqlConnection.connect(connection);

    List<Progress> progressList = [];

    var result = await conn.query("SELECT * FROM dbProgress WHERE ClientID = ? ORDER BY CurrentDate ASC", [id]);

    if(result.isNotEmpty){
      for(var row in result){
        Progress progress = toProgress(row); //convert row to progress object

        if(progress != null){
          progressList.add(progress); //if progress is available, add it to the list
        }
      }
    }

    await conn.close();
    return progressList;
  }

  Future<int> updateProgress(Progress progress) async {  //add new progress for logged in client
    var conn = await MySqlConnection.connect(connection);

    var result = await conn.query("INSERT INTO dbProgress (clientID, CurrentWeight, Height, BMI, BMI_Rating, TrainingGoal, CurrentDate)"
        " VALUES (?,?,?,?,?,?,?)",
        [progress.clientID, progress.currentWeight, progress.currentHeight, progress.bmi, progress.bmiRating, progress.trainingGoal, progress.currentDate]);

    await conn.close();

    return result.insertId;

  }

  Future<int> editProgress(Progress progress) async { //edit old progress data
    var conn = await MySqlConnection.connect(connection);

    var result = await conn.query("UPDATE dbProgress SET CurrentWeight=?, Height=?, BMI=?, BMI_Rating=?, TrainingGoal=? WHERE progressID = ?",
        [progress.currentWeight, progress.currentHeight, progress.bmi, progress.bmiRating, progress.trainingGoal, progress.progressID]);

    await conn.close();

    return result.insertId;

  }

  Future<String> deleteProgress(int id) async { //delete progress data
    String res = '';
    var conn = await MySqlConnection.connect(connection);

    try{
      await conn.query("DELETE FROM dbProgress WHERE progressID = ? ",[id]);
    }
    catch(e){
      res = e.toString();
    }

    await conn.close();

    return res;
  }

  Future<String> updateAccount(Client client) async { //update client account details
    String res = '';
    var conn = await MySqlConnection.connect(connection);

    try{
      await conn.query("UPDATE dbClients SET FirstName=?, LastName=?, Gender=?, Tele=?, DOB=?, Email=? WHERE clientID = ?",
          [client.firstName, client.lastName, client.gender, client.tele, client.dob, client.email, client.clientID]);
    }
    catch(e){
      res = e.toString();
    }

    await conn.close();

    return res;
  }

  Future<String> updatePassword(String password, int id) async{ //update account password
    String res = '';
    var conn = await MySqlConnection.connect(connection);

    try{
      await conn.query("UPDATE dbClients SET Password=? WHERE clientID = ?",
          [password, id]);
    }
    catch(e){
      res = e.toString();
    }

    await conn.close();

    return res;
  }

  Future<MealPlan> getMealPlan (int clientID ) async {  //get meal plan for client
    var conn = await MySqlConnection.connect(connection);
    MealPlan mealPlan;
    var result = await conn.query('SELECT * from dbMeals WHERE clientID = ?', [clientID]);

    if(result.isEmpty){
      print('no data');
    }
    else{
      for (var row in result){
        mealPlan = toMealPlan(row);
      }
    }

    await conn.close();

    return mealPlan;

  }

}