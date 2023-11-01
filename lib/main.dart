import 'package:flutter/material.dart';
import 'start_page.dart';
import "gametime.dart";
import '/user_auth/loginpage.dart';
import '/user_auth/registerpage.dart';

void main() {
  runApp(const Router());
}

class Router extends StatelessWidget {
  const Router({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "VizFit AI",
      initialRoute: '/',
      routes: {
        "/": (context) => const StartPage(),
        "/gametime": (context) => const Gametime(),
        "/loginpage": (context) => const LoginPage(),
        "/registerpage": (context) => const RegisterPage()
      },
    );
  }
}


/// MyApp is the Main Application.
