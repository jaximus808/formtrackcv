import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameChange extends StatefulWidget {
  const NameChange({Key? key}) : super(key: key);
  @override
  State<NameChange> createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  static Future changeName(name) async {
    if (name.trim() == "") return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", name);
  }

  final TextEditingController myController = TextEditingController();
  //late SharedPreferences prefs;

  String name = "loading...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
        appBar: AppBar(
          backgroundColor: Colors.blue,
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
                TextSpan(
                  text: "Change Name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: myController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Name!',
                    focusColor: Colors.white),
              ),
            ),
            TextButton(
                onPressed: () async {
                  await changeName(myController.text);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Change Name",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                )),
            Builder(
              builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "Done",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  )),
            )
          ],
        ));
  }
}
