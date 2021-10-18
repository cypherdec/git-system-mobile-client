import 'dart:convert';

MealJson mealJsonFromJson(String str) => MealJson.fromJson(json.decode(str));

String mealJsonToJson(MealJson data) => json.encode(data.toJson());

class MealJson {
  MealJson({
    this.proteinName1,
    this.proteinName2,
    this.proteinName3,
    this.proteinAmount1,
    this.proteinAmount2,
    this.proteinAmount3,
    this.carbName1,
    this.carbName2,
    this.carbName3,
    this.carbsAmount1,
    this.carbsAmount2,
    this.carbsAmount3,
    this.fatName1,
    this.fatName2,
    this.fatName3,
    this.fatAmount1,
    this.fatAmount2,
    this.fatAmount3,
  });

  String proteinName1;
  String proteinName2;
  String proteinName3;
  String proteinAmount1;
  String proteinAmount2;
  String proteinAmount3;
  String carbName1;
  String carbName2;
  String carbName3;
  String carbsAmount1;
  String carbsAmount2;
  String carbsAmount3;
  String fatName1;
  String fatName2;
  String fatName3;
  String fatAmount1;
  String fatAmount2;
  String fatAmount3;

  factory MealJson.fromJson(Map<String, dynamic> json) => MealJson(  //convert json string to meal object
    proteinName1: json["proteinName1"],
    proteinName2: json["proteinName2"],
    proteinName3: json["proteinName3"],
    proteinAmount1: json["proteinAmount1"],
    proteinAmount2: json["proteinAmount2"],
    proteinAmount3: json["proteinAmount3"],
    carbName1: json["carbName1"],
    carbName2: json["carbName2"],
    carbName3: json["carbName3"],
    carbsAmount1: json["carbsAmount1"],
    carbsAmount2: json["carbsAmount2"],
    carbsAmount3: json["carbsAmount3"],
    fatName1: json["fatName1"],
    fatName2: json["fatName2"],
    fatName3: json["fatName3"],
    fatAmount1: json["fatAmount1"],
    fatAmount2: json["fatAmount2"],
    fatAmount3: json["fatAmount3"],
  );

  Map<String, dynamic> toJson() => {
    "proteinName1": proteinName1,
    "proteinName2": proteinName2,
    "proteinName3": proteinName3,
    "proteinAmount1": proteinAmount1,
    "proteinAmount2": proteinAmount2,
    "proteinAmount3": proteinAmount3,
    "carbName1": carbName1,
    "carbName2": carbName2,
    "carbName3": carbName3,
    "carbsAmount1": carbsAmount1,
    "carbsAmount2": carbsAmount2,
    "carbsAmount3": carbsAmount3,
    "fatName1": fatName1,
    "fatName2": fatName2,
    "fatName3": fatName3,
    "fatAmount1": fatAmount1,
    "fatAmount2": fatAmount2,
    "fatAmount3": fatAmount3,
  };
}
