

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;


  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
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
                fontFamily: 'SmHouse', fontSize: 40,
              ),
              ),
              // Additional content can be added below the title if needed
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
          child: TextField(
            cursorColor: const Color.fromRGBO(82, 130, 103, 1.0), // Set the cursor color here
            controller: emailController,
            decoration:  const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',

              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(82, 130, 103, 1.0),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: TextField(
            cursorColor: const Color.fromRGBO(82, 130, 103, 1.0), // Set the cursor color here
            obscureText: true,
            controller: passwordController,
            decoration:  const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Password',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromRGBO(82, 130, 103, 1.0),
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
            foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
          ),
          child:  Text('Forgot Password?',
          ),

        ),
        Container(
            height: 80,
            padding: const EdgeInsets.fromLTRB(10,40,10,5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF63AFC0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                ),
              ),
              onPressed: () {  },
              child: const Text('Log In', style: TextStyle(color: Colors.white),
              ),
         //     onPressed: () => logInButtonPressed(
         //         emailController.text, passwordController.text),
         //
    //
    //   )),

            )
        )
      ],

    );
  }

}