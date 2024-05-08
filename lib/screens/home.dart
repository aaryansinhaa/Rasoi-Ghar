import 'dart:convert';
import 'dart:developer';

import 'package:bhojan/Model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  List<RecipeModel> recipeList = [];

  TextEditingController searchController = new TextEditingController();

  static const String _YOUR_APP_ID = "c768f5de";
  static const String _YOUR_APP_KEY = "acf684e6eb5b1a594c92d7a5ec4845e0";

  getRecipe(String searchQuery) async {
    Uri url = Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&q={$searchQuery}&app_id=c768f5de&app_key=acf684e6eb5b1a594c92d7a5ec4845e0");
    http.Response apiresponse = await http.get(url);
    Map data = await jsonDecode(apiresponse.body);
    // log(data.toString());
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = new RecipeModel();
        recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
        // log(recipeList.toString());
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRecipe("Paneer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Find best recipes\nfor cooking",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                // searchBox
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey.shade200,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.search_sharp),
                      ),
                      onTap: () {
                        if ((searchController.text).replaceAll(" ", "") == "") {
                          print("blank");
                        } else {
                          getRecipe(searchController.text);
                        }
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: GoogleFonts.poppins(
                            color: Colors.grey, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Let's Cook Something!",
                          border: InputBorder.none,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if ((searchController.text).replaceAll(" ", "") ==
                              "") {
                            print("blank");
                          } else {
                            getRecipe(searchController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Trending now 🔥",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    recipeList[index].imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.maxFinite,
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                  ),
                                ),
                                Positioned(
                                  right: 1,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 1, 5, 0),
                                    decoration: BoxDecoration(
                                        color: Colors.black38.withAlpha(100),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                        )),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.local_fire_department,
                                            color: Colors.white),
                                        Text(
                                          recipeList[index]
                                                  .calories
                                                  .toString()
                                                  .substring(0, 6) +
                                              " kCal",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          recipeList[index].label
                                          /*.toString()
                                                  .substring(0, 10) +
                                              "...."*/
                                          ,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            child: const Icon(
                                                Icons.trending_up_outlined)),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
