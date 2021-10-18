import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grit_app/models/recipe_json_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayRecipe extends StatefulWidget {

  final RecipeJson recipeJson;

  DisplayRecipe(this.recipeJson);

  @override
  _DisplayRecipeState createState() => _DisplayRecipeState();
}

class _DisplayRecipeState extends State<DisplayRecipe> {

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Could not open url'),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      child: Text('Meal 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: Text(widget.recipeJson.meal1,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () async {
                        String url = widget.recipeJson.mealurl1;

                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{'my_header_key': 'my_header_value'},
                          );
                        } else {
                          _showToast(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      child: Text('Meal 2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: Text(widget.recipeJson.meal2,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () async {
                        String url = widget.recipeJson.mealurl2;

                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{'my_header_key': 'my_header_value'},
                          );
                        } else {
                          _showToast(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      child: Text('Meal 3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: Text(widget.recipeJson.meal3,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () async {
                        String url = widget.recipeJson.mealurl3;

                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{'my_header_key': 'my_header_value'},
                          );
                        } else {
                          _showToast(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
