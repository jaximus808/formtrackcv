import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPage();
}
// class ResponseObject {
//   final bool fail;
//   final String msg;
//   final String token;

//   const ResponseObject({required this.fail, required this.msg, required this.token});

//   factory Album.fromJson(Map<String, dynamic> json) {
//     return Album(
//       id: json['id'] as int,
//       title: json['title'] as String,
//     );
//   }
// }

class _RegisterPage extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }


  Future<dynamic> setToken(String token) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
  }

  Future<Map<String, dynamic>> RegisterUser(String username, String email, String password) async 
  {
    final response =  await http.post(
      Uri.parse('http://10.232.188.70:3000/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password':password,
        'email':email
      }),
    );

    if(response.statusCode == 200)
    {
      return jsonDecode(response.body);
    }
    else 
    {
      throw Exception("Could not create resource froms server");
    }

  }


  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //late SharedPreferences prefs;

  String name = "loading...";

  String responseString = "";
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
                  text: "Register Here",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12,left:24,right:24),
              child: Column(
                children:[
                  const Padding(
                    padding:EdgeInsets.all(16),
                    child:AutoSizeText.rich(
                    TextSpan(
                      text: "Username:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(fontSize: 20),
                    )
                  ),
                  TextField(
                    controller: usernameController, 
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText:"Username",
                        hintStyle:TextStyle(color: Color.fromRGBO(255,255,255,0.4)),
                        focusColor: Colors.white
                        
                    ),
                  ),
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
                  Padding(
                    padding:const EdgeInsets.all(16),
                    child: AutoSizeText(
                    responseString,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  ),
                     
                    
                  
                ]
              )
            ),
            
            Builder(
              builder:(context) =>TextButton(
                onPressed: () async {
                  //await changeName(myController.text);
                  Map<String, dynamic> data= await RegisterUser(usernameController.text, emailController.text, passwordController.text);

                  print(data["token"]);
                  if(!data.containsKey("fail")) return; 

                  if(!data["fail"] && data.containsKey("token"))
                  {
                    setToken(data["token"])
                    .then((result){
                      Navigator.of(context).pop();
                    });
                    
                  }
                  if(data["fail"])
                  {
                    if( !data.containsKey("msg")) return; 
                    setState(() {
                      responseString = data["msg"];
                    });
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                )
              ,),
            ),
            
          ],
        ));
  }
}
