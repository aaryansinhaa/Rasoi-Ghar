import 'dart:convert';
import 'dart:developer';
import 'package:bhojan/Model/model.dart';
import 'package:bhojan/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Search extends StatefulWidget {
  String query;
  Search(this.query);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  static const String _YOUR_APP_ID = "c768f5de";
  static const String _YOUR_APP_KEY = "acf684e6eb5b1a594c92d7a5ec4845e0";

  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=$_YOUR_APP_ID&app_key=$_YOUR_APP_KEY&random=true";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        setState(() {
          isLoading = false;
        });
        log(recipeList.toString());
      });
    });

    recipeList.forEach((Recipe) {
      print(Recipe.label);
      print(Recipe.calories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipes(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results!"),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                //Search Bar
                SafeArea(
                  child: Container(
                    //Search Wala Container

                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Search(searchController.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Let's Cook Something!"),
                            onSubmitted: (value) {
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("blank");
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Search(searchController.text)));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recipeList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Card(
                                  margin: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Image.network(
                                            recipeList[index].imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 200,
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Text(
                                                recipeList[index].label,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ))),
                                      Positioned(
                                        right: 0,
                                        height: 40,
                                        width: 80,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10))),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.local_fire_department,
                                                    size: 15,
                                                  ),
                                                  Text(recipeList[index]
                                                      .calories
                                                      .toString()
                                                      .substring(0, 6)),
                                                ],
                                              ),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
