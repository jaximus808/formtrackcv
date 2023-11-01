import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  static Future changeName(name) async {
    if (name.trim() == "") return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", name);
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                  text: "Login Page",
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
              child: Column(
                children:[
                  const Padding(
                    padding:EdgeInsets.all(16),
                    child:AutoSizeText.rich(
                    TextSpan(
                      text: "Email:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(fontSize: 20),
                    )
                  ),
                  TextField(
                    controller: emailController, 
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:"Email",
                        hintStyle:TextStyle(color: Color.fromRGBO(255,255,255,0.4)),
                        focusColor: Colors.white
                        
                    ),
                  ),
                
                const Padding(
                    padding:EdgeInsets.all(16),
                    child:AutoSizeText.rich(
                    TextSpan(
                      text: "Password:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(fontSize: 20),
                    )
                  ),
                  TextField(
                    controller: passwordController, 
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:"Password",
                        hintStyle:TextStyle(color: Color.fromRGBO(255,255,255,0.4)),
                        focusColor: Colors.white
                        
                    ),
                  ),
                ]
              )
            ),
            Builder(
              builder: (context) => TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, "/registerpage");
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Dont have an account? register here!",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )),
                  )),
            ),
            TextButton(
                onPressed: () async {
                  //await changeName(myController.text);
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                )),
            
          ],
        ));
  }
}
