import 'package:flutter/material.dart';
import 'start_page.dart';
import "gametime.dart";

void main() {
  runApp(const Router());
}

class Router extends StatelessWidget {
  const Router({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Form Track AI",
      initialRoute: '/',
      routes: {
        "/": (context) => const StartPage(),
        "/gametime": (context) => const Gametime()
      },
    );
  }
}


/// MyApp is the Main Application.
