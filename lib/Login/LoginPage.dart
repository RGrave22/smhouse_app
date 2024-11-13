

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


  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome', style: TextStyle(
                fontFamily: 'Montserrat'
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
            decoration:  InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: 'Password',
              focusedBorder: const UnderlineInputBorder(
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
            foregroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(121, 135, 119, 1)),
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
                backgroundColor: const Color.fromRGBO(82, 130, 103, 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
                ),
              ),
              onPressed: () {  },
              child: Text('Log In',
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