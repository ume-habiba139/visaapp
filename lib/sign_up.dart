import 'package:flutter/material.dart';
import 'package:visaapp/Database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Signup(),
    );
  }
}
class Signup extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: const Color.fromARGB(255, 145, 3, 53),
              title: Text(
                "SIGN UP",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // First Name Field
                  buildTextField(
                    controller: firstNameController,
                    hintText: "First Name",
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  // Last Name Field
                  buildTextField(
                    controller: lastNameController,
                    hintText: "Last Name",
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  buildTextField(
                    controller: emailController,
                    hintText: "E-mail",
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  buildTextField(
                    controller: passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // Confirm Password Field
                  buildTextField(
                    controller: confirmpasswordController,
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock_open,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  // Age Field
                  buildTextField(
                    controller: ageController,
                    hintText: "Age",
                    prefixIcon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Gender Field
                  buildTextField(
                    controller: genderController,
                    hintText: "Male/Female",
                    prefixIcon: Icons.group,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text ==
                          confirmpasswordController.text) {
                        User newUser = User(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          confirmPassword: confirmpasswordController.text,
                          age: int.parse(ageController.text),
                          gender: genderController.text,
                        );

                        await DatabaseHelper.instance.insertUser(newUser);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('User signed up successfully')
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text("OR"),
                  Container(
                    width: 210,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 145, 3, 53),
                      ),
                      child: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // A helper function to create text fields
  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: 320,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: Icon(prefixIcon),
          filled: true,
          fillColor: const Color.fromARGB(255, 229, 226, 229),
        ),
      ),
    );
  }
}
