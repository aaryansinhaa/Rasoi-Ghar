import 'package:bhojan/screens/home.dart';
import 'package:bhojan/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      title: "Bhojan App",
      routes: {
        "/": (context) => const Onboarding(),
        "/home": (context) => const HomeScreen(),
        "/onboarding": (context) => const Onboarding(),
      },
    );
  }
}
