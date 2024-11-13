

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smhouse_app/MainPage.dart';
import 'package:smhouse_app/Register/RegisterPage.dart';

import '../DB/DB.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalDB db = LocalDB('SmHouse');

  late TextEditingController usernameController;
  late TextEditingController passwordController;

  bool _obscureText = true;

  @override
  void initState() {
    initDatabase();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  Future<void> initDatabase() async {
    await db.deleteTables();
    await db.initDB();
    await db.insertDefaultUsers();
  }

  Future<void> handleLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    bool loginSuccess = await db.login(username, password);

    if (loginSuccess) {
      _showAlertDialog('Login Successful', 'Welcome, $username!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(username: username),
        ),
      );
    } else {
      _showAlertDialog('Login Failed', 'Incorrect username or password.');
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
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
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: TextField(
            cursorColor: const Color(0xFF153043), // Set the cursor color here
            controller: usernameController,
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
        TextButton(
          onPressed: () {
         //   _showResetPasswordDialog(context);
          },
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF153043)
            ),
          ),
          child:  const Text('Forgot Password?',
          ),

        ),
        Container(
            height: 80,
            padding: const EdgeInsets.fromLTRB(10,40,10,0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF63AFC0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                ),
              ),
              onPressed: () {
                handleLogin();
              },
              child: const Text('Log In', style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
        ),
        Container(
          //alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Color(0xFF153043)
              ),
            ),
            child:  const Text('Don´t have an account?'),
          ),
        )
      ],

    );
  }

}