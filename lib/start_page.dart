import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Form Track AI!"),
          leadingWidth: 100,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome to Form Track AI",
                  style: TextStyle(fontSize: 24),
                ),
                Icon(Icons.sports_gymnastics)
              ],
            ),
            Builder(
              builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/gametime");
                  },
                  child: const Text("gametime uwu")),
            )
          ],
        ));
  }
}
