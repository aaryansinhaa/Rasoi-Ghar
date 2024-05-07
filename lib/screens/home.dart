import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = new TextEditingController();

  static const String _YOUR_APP_ID = "c768f5de";
  static const String _YOUR_APP_KEY = "acf684e6eb5b1a594c92d7a5ec4845e0";
  String? searchQuery;

  getRecipe(searchQuery) async {
    Uri url = Uri.parse(
        "https://api.edamam.com/api/recipes/v2?type=public&q={$searchQuery}&app_id=c768f5de&app_key=acf684e6eb5b1a594c92d7a5ec4845e0");
    http.Response apiresponse = await http.get(url);
    Map data = jsonDecode(apiresponse.body);
    log(data.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipe("Chicken");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Let's Cook Something!",
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if ((searchController.text).replaceAll(" ", "") == "") {
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
