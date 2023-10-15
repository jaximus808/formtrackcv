import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartPage extends StatefulWidget {
  const StartPage({
    Key? key,
    required this.newLift,
  }) : super(key: key);

  final int newLift;
  @override
  State<StartPage> createState() => _StartPageStateS();
}

class _StartPageStateS extends State<StartPage> {
  late SharedPreferences prefs;

  String name = "loading...";

  @override
  void initState() {
    super.initState();
    createprefs();
  }

  Future<void> createprefs() async {
    prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString("username");
    if (username == null) {
      setState(() {
        name = "User";
      });
    } else {
      setState(() {
        name = username;
      });
    }

    List<String>? lifts = prefs.getStringList("username");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/changeName");
            },
            child: Text(name),
          ),
          title: const Text(
            "VizFit AI 🏋️‍♀️",
            style: TextStyle(fontSize: 30),
          ),
          leadingWidth: 100,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: AutoSizeText.rich(
                TextSpan(children: [
                  TextSpan(
                    text: "Welcome to",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextSpan(
                      text: " VizFit AI",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(52, 152, 219, 1)))
                ]),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 40),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: AutoSizeText(
                "Experience precise and confident deadlifts with our cutting-edge app. Simply face the camera for automatic form tracking. We calibrate your torso height for accuracy and provide real-time feedback, ensuring perfect form on the go. Click get started and ensure your form is perfect now!",
                style: TextStyle(
                    fontSize: 20, color: Color.fromRGBO(204, 204, 204, 1)),
                textAlign: TextAlign.center,
                maxLines: 6,
              ),
            ),
            Builder(
              builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/gametime");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  )),
            )
          ],
        ));
  }
}
