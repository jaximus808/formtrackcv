import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            "Form Track AI",
            style: TextStyle(fontSize: 40),
          ),
          leadingWidth: 100,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AutoSizeText(
              "Welcome to Form Track AI ",
              maxLines: 1,
              textAlign: TextAlign.center,
              maxFontSize: 50,
            ),
            const AutoSizeText(
              "Experience precise and confident deadlifts with our cutting-edge app. Simply face the camera for automatic form tracking. We calibrate your torso height for accuracy and provide real-time feedback, ensuring perfect form on the go. Click get started and ensure your form is perfect now!",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
              maxLines: 6,
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
