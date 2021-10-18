class MealPlan{
  int mealID;
  int clientID;
  String mealString;
  DateTime date;

  MealPlan(this.clientID, this.mealID, this.mealString, this.date);
}

MealPlan toMealPlan(var row){
  MealPlan mealPlan = new MealPlan(
    row[0],
    row[1],
    row[2].toString(),
    row[3]
  );

  return mealPlan;
}


