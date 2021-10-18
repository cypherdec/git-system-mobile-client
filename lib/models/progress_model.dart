class Progress{ //progress model
  int progressID;
  int clientID;
  int currentWeight;
  int currentHeight;
  String trainingGoal;
  DateTime currentDate;
  double bmi;
  String bmiRating;

  Progress(this.progressID, this.clientID, this.currentWeight, this.currentHeight, this.bmi, this.bmiRating, this.trainingGoal, this.currentDate );
}

Progress toProgress(var row){  //converts data from sql query to progress object
  Progress progress = new Progress(
      row[0],
      row[1],
      row[2],
      row[3],
      row[4],
      row[5],
      row[6],
      row[7],
  );
  return progress;
}