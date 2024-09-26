import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visaapp/Database/database_helper.dart';
import 'package:visaapp/admin/home_screen.dart';
import 'package:visaapp/sign_up.dart';
import 'package:visaapp/user/home_screen.dart';


void main() {
  runApp(Signin());
}
class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignIn(),
    );
  }
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = "User";

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    var user = await DatabaseHelper.instance.getUserByEmail(email);

    if (user != null && user['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUserEmail', email);

      // Navigate based on selected role
      if (selectedRole == "Admin") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>MyhomeAD()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Myhome1()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: const Color.fromARGB(255, 145, 3, 53),
              title: const Text(
                "SIGN IN",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 200,
                backgroundColor: Color.fromARGB(255, 229, 226, 229),
                backgroundImage: AssetImage('assets/person.png'),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "SIGN IN!",
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "E-mail",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 320,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Role selection
                  Container(
                    width: 320,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: "Select Role",
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 229, 226, 229),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedRole,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: [
                            DropdownMenuItem(child: Text("User"), value: "User"),
                            DropdownMenuItem(child: Text("Admin"), value: "Admin"),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRole = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),


                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text("OR"),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 145, 3, 53),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
