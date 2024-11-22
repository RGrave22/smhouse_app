

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smhouse_app/Login/LoginPage.dart';
import 'package:smhouse_app/main.dart';

import '../DB/DB.dart';
import '../Data/User.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LocalDB db = LocalDB('SmHouse');
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController confirmationController;

  bool _obscureText = true;

  get crossAxisAlignment => null;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    confirmationController = TextEditingController();

    super.initState();
  }

  Future<void> _showAlertDialog(BuildContext context, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(

          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {

    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmationPassword = confirmationController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmationPassword.isEmpty) {
      _showAlertDialog(context, "All fields are required.");
      return;
    }

    if (password != confirmationPassword) {
      _showAlertDialog(context,"Passwords do not match.");
      return;
    }

    bool exists = await db.userExist(username);
    if (exists) {
      _showAlertDialog(context, "User already exists with this username.");
    } else {

      User newUser = User(username: username, password: password, email: email, casa: "House");
      await db.registerUser(newUser);
      _showAlertDialog(context, "User registered successfully.");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: Center(
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 49, 0, 0),
            child: Image.asset(
              'assets/Logo_init.jpeg',
              width: 300,
              height: 200,
            ),
          ),
          SingleChildScrollView(
            child: Container(
                width: 350.0,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 70),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child:  const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'SmHouse', style: TextStyle(
                            fontFamily: 'SmHouse', fontSize: 40, color: Color(0xFF181116),
                          ),
                          ),
                          // Additional content can be added below the title if needed
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: TextField(
                        cursorColor: const Color(0xFF153043), // Set the cursor color here
                        controller: usernameController,
                        decoration:  const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Username',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF153043),
                              ),
                            ),
                            suffixIcon: Icon(Icons.person, color: Color(0xFF153043))
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: TextField(
                        cursorColor: const Color(0xFF153043), // Set the cursor color here
                        controller: emailController,
                        decoration:  const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Email',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF153043),
                              ),
                            ),
                            suffixIcon: Icon(Icons.person, color: Color(0xFF153043))
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: TextField(
                        cursorColor: const Color(0xFF181116), // Set the cursor color here
                        obscureText: _obscureText,
                        controller: passwordController,
                        decoration:  InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Password',
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF153043),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;  // Toggle visibility on tap
                              });
                            },
                            child: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,  // Change icon based on _obscureText
                              color: Color(0xFF153043),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: TextField(
                        cursorColor: const Color(0xFF181116), // Set the cursor color here
                        obscureText: _obscureText,
                        controller: confirmationController,
                        decoration:  InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Confirm password',
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF153043),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;  // Toggle visibility on tap
                              });
                            },
                            child: Icon(
                              _obscureText ? Icons.visibility : Icons.visibility_off,  // Change icon based on _obscureText
                              color: Color(0xFF153043),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 80,
                        padding: const EdgeInsets.fromLTRB(10,40,10,0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                            ),
                          ),
                          onPressed: () {
                            registerUser();
                          },
                          child: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                    ),
                    Container(
                      //alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MyApp()),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF153043)
                          ),
                        ),
                        child:  const Text('Already have an account?'),
                      ),
                    )
                  ],
                )
            )
        )
      ],

    ))));
  }

}