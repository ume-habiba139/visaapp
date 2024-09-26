import 'package:flutter/material.dart';
import 'package:visaapp/sign_up.dart';
import 'package:visaapp/signin.dart';
void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:   Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/S10.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(children: [
              SizedBox(height: 190,),
              Icon(
                Icons.account_circle,
                size: 150,
                color: Color.fromARGB(255, 145, 3, 53),
              ),
              SizedBox(height: 10,),
              const Text("WELCOME!",
                style: TextStyle(
                  color:Color.fromARGB(255, 145, 3, 53),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signin ()),
                  );
                },
                child: Container(
                  color: Color.fromARGB(255, 145, 3, 53),
                  width: 200,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Sign IN",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Text("or"),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Container(
                  color: Color.fromARGB(255, 145, 3, 53),
                  width: 200,
                  height: 40,
                  child: Center(
                    child: Text(
                      "Sign UP",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              )

            ],),
          ),
        ) );
  }
}
