import 'dart:convert';

RecipeJson recipeJsonFromJson(String str) => RecipeJson.fromJson(json.decode(str));

String recipeJsonToJson(RecipeJson data) => json.encode(data.toJson());

class RecipeJson {
  RecipeJson({
    this.meal1,
    this.mealurl1,
    this.meal2,
    this.mealurl2,
    this.meal3,
    this.mealurl3,
  });

  String meal1;
  String mealurl1;
  String meal2;
  String mealurl2;
  String meal3;
  String mealurl3;

  factory RecipeJson.fromJson(Map<String, dynamic> json) => RecipeJson( //convert json string to recipe object
    meal1: json["meal1"],
    mealurl1: json["mealurl1"],
    meal2: json["meal2"],
    mealurl2: json["mealurl2"],
    meal3: json["meal3"],
    mealurl3: json["mealurl3"],
  );

  Map<String, dynamic> toJson() => {
    "meal1": meal1,
    "mealurl1": mealurl1,
    "meal2": meal2,
    "mealurl2": mealurl2,
    "meal3": meal3,
    "mealurl3": mealurl3,
  };
}
