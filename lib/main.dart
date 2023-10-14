import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'start_page.dart';
import "gametime.dart";

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

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
        "/gametime": (context) => Gametime(cameras: _cameras)
      },
    );
  }
}


/// MyApp is the Main Application.
