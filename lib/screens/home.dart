import 'dart:convert';
import 'dart:math';

import 'package:bhojan/Model/model.dart';
import 'package:bhojan/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  bool isCategoryLoading = true;
  List<RecipeModel> recipeList = [];
  List<RecipeModel> trendingRecipeList = [];
  List<String> cuisineList = [
    "Indian",
    "Italian",
    "Asian",
    "Chinese",
    "Japanese",
    "Korean",
    "French",
    "Mexican",
  ];
  List<bool> _hasBeenPressed = List.filled(8, false);
  TextEditingController searchController = TextEditingController();
  static const String _YOUR_APP_ID = "c768f5de";
  static const String _YOUR_APP_KEY = "acf684e6eb5b1a594c92d7a5ec4845e0";
  Random rng = Random();

  @override
  void initState() {
    super.initState();
    getRecipe("Indian");
    getTrendingRecipe(mealType[rng.nextInt(4)]);
  }

  getRecipe(String searchQuery) async {
    Uri url = Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&q={$searchQuery}&app_id=c768f5de&app_key=acf684e6eb5b1a594c92d7a5ec4845e0&random=true");
    http.Response apiresponse = await http.get(url);
    Map data = jsonDecode(apiresponse.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
        recipeList.add(recipeModel);
      });
      isLoading = false;
    });
  }

  getTrendingRecipe(String searchQuery) async {
    Uri url = Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&q={$searchQuery}&app_id=c768f5de&app_key=acf684e6eb5b1a594c92d7a5ec4845e0&random=true");
    http.Response apiresponse = await http.get(url);
    Map data = jsonDecode(apiresponse.body);
    setState(() {
      data["hits"].forEach((element) {
        RecipeModel recipeModel = RecipeModel.fromMap(element["recipe"]);
        trendingRecipeList.add(recipeModel);
      });
      isLoading = false;
    });
  }

  List<String> mealType = [
    "breakfast",
    "brunch",
    "lunch/dinner",
    "snack",
    "teatime"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: Text(
                  "Find best recipes\nfor cooking",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if ((searchController.text).replaceAll(" ", "") !=
                              "") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Search(searchController.text)),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.search_sharp),
                        ),
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
                            if (value.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Search(value)),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Trending now 🔥",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                child: isLoading
                    ? Center(
                        child: SpinKitWave(
                          color: Colors.red,
                          size: 50,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trendingRecipeList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              final url =
                                  Uri.parse(trendingRecipeList[index].url);
                              try {
                                await launchUrl(url,
                                    mode: LaunchMode.inAppWebView);
                              } catch (e) {
                                print("Error Loading in App web view.");
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      trendingRecipeList[index].imageUrl,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    trendingRecipeList[index].label,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.local_fire_department,
                                          color: Colors.red),
                                      Text(
                                        "${trendingRecipeList[index].calories.toStringAsFixed(1)} kCal",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Popular category",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  //buttons
                  SizedBox(
                    height: 50,
                    width: 500,
                    child: ListView.builder(
                        itemCount: cuisineList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: TextButton(
                              onPressed: () {
                                setState(
                                  () {
                                    for (int i = 0;
                                        i < _hasBeenPressed.length;
                                        i++) {
                                      if (i != index) {
                                        _hasBeenPressed[i] = false;
                                      } else {
                                        _hasBeenPressed[i] =
                                            !_hasBeenPressed[i];
                                        recipeList.clear();

                                        getRecipe(cuisineList[i]);
                                      }
                                    }
                                  },
                                );
                              },
                              child: Text(
                                cuisineList[index],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: _hasBeenPressed[index]
                                    ? Colors.red
                                    : Colors.transparent,
                                foregroundColor: _hasBeenPressed[index]
                                    ? Colors.white
                                    : Colors.red,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    recipeList.length,
                    (index) => GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(recipeList[index].url);

                        await launchUrl(url, mode: LaunchMode.inAppWebView);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                recipeList[index].imageUrl,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                recipeList[index].label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.local_fire_department,
                                      color: Colors.red),
                                  Text(
                                    "${recipeList[index].calories.toStringAsFixed(1)} kCal",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
