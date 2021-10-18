import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:grit_app/controllers/database_controller.dart';
import 'package:grit_app/models/progress_model.dart';
import 'package:grit_app/shared/constants.dart';
import 'package:grit_app/shared/loading.dart';
import 'package:intl/intl.dart';

class EditProgressForm extends StatefulWidget {

  final Progress progress;
  final Function() callback;

  EditProgressForm(this.progress, this.callback);

  @override
  _EditProgressFormState createState() => _EditProgressFormState();
}

class _EditProgressFormState extends State<EditProgressForm> {

  final _formKey  = GlobalKey<FormState>();  //used for validation

  bool loading = false;
  Database database = new Database();

  List<String> goals = ['Weight Gain', 'Weight Loss'];

  //form values
  String newWeight ='' ;
  String newHeight='';
  String newGoal;
  String stringBmi;
  String bmiRating;
  String error ='' ;
  Color errorColor;

  var bmiController = TextEditingController();
  var ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();  //set default values in case no change
    bmiController.text = widget.progress.bmi.toStringAsFixed(2);
    ratingController.text = widget.progress.bmiRating;
    newHeight = widget.progress.currentHeight.toString();
    newWeight = widget.progress.currentWeight.toString();
    newGoal = widget.progress.trainingGoal;
    bmiRating = widget.progress.bmiRating;
  }


  @override
  Widget build(BuildContext context) {

    void calculateBMI()  //method to calculate bmi and assign a rating
    {
      double bmHeight;
      double bmiWeight;

      if(newHeight == ''){
        bmHeight = double.parse(widget.progress.currentHeight.toString());
      }
      else{
        bmHeight = double.parse(newHeight);
      }

      if(newWeight == ''){
        bmiWeight = double.parse(widget.progress.currentWeight.toString());
      }
      else{
        bmiWeight = double.parse(newWeight);
      }

      double height = bmHeight / 100;
      double bmi = bmiWeight / (height * height);

      if (bmi < 18.5)
      {
        bmiRating = "Underweight";
      }
      else if (bmi < 24.9)
      {
        bmiRating = "Normal Weight";
      }
      else if (bmi < 29.9)
      {
        bmiRating = "Overweight";
      }
      else
      {
        bmiRating = "Obese";
      }

      setState(() {
        bmiController.text = bmi.toStringAsFixed(2);
        ratingController.text = bmiRating;
      });

    }

    return loading ? Loading() :  Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text(
              'Edit Progress for ${DateFormat('yyyy-MM-dd').format(widget.progress.currentDate)}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                style: textStyleOrange,
                initialValue: widget.progress.currentWeight.toString(),
                decoration: textInputDecoration.copyWith(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter New Weight' : null,
                onChanged:(String value) {
                  setState((){
                    newWeight = value;
                    calculateBMI();
                  });}
            ),
            SizedBox(height: 20.0),
            TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                style: textStyleOrange,
                initialValue: widget.progress.currentHeight.toString(),
                decoration: textInputDecoration.copyWith(labelText: 'Height (cm)', labelStyle: TextStyle(color: Colors.white)),
                validator: (val) => val.isEmpty ? 'Enter New Height' : null,
                onChanged:(String value) {
                  setState((){
                    newHeight = value;
                    calculateBMI();
                  });}
            ),
            SizedBox(height: 20.0),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.black,
              ),
              child:  DropdownButtonFormField(
                  style: TextStyle(
                    color: Colors.amber,
                    backgroundColor: Colors.black,
                    decorationColor: Colors.black,
                  ),
                  decoration: textInputDecoration.copyWith(labelText: 'Training Goal', labelStyle: TextStyle(color: Colors.white)),
                  value: newGoal ?? widget.progress.trainingGoal,
                  items: goals.map((users){
                    return DropdownMenuItem(
                      value: users,
                      child: Text('$users'),
                    );
                  }).toList(),
                  onChanged:(String value) {
                    setState((){
                      newGoal = value;
                    });}
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              style: textStyleOrange,
              enabled: false,
              controller: bmiController,
              decoration: textInputDecoration.copyWith(labelText: 'BMI', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              style: textStyleOrange,
              enabled: false,
              controller: ratingController,
              decoration: textInputDecoration.copyWith(labelText: 'BMI Rating', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text(
                  'Edit Progress',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {

                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true); //set loading to true to display loading page on async

                    int cWeight = int.parse(newWeight);
                    int cHeight = int.parse(newHeight);
                    double cBmi = double.parse(bmiController.text);
                    String cRating = ratingController.text;

                    DateTime date = DateTime.now();

                    Progress progress = new Progress(widget.progress.progressID, widget.progress.clientID, cWeight, cHeight, cBmi, cRating, newGoal, date);

                    int result = await  database.editProgress(progress);

                    if (result == null) {
                      setState(() {
                        error = 'Error, something went wrong';
                        errorColor = Colors.red;
                        loading = false; //set loading to false to hide loading page
                      });
                    }
                    else{
                      setState(() {
                        error = 'Successfully updated progress';
                        errorColor = Colors.green;
                        loading = false; //set loading to false to hide loading page
                        widget.callback(); //trigger callback to update progress lists in chain
                      });
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
