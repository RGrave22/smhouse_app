import 'package:flutter/material.dart';
import '../../../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


/// A page for managing user settings.
///
/// This page allows users to modify their settings and perform various actions related to their account.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}


class _SettingsPageState extends State<SettingsPage> {

  /// Sends a password reset email to the user's email address.
  /// This method triggers the password reset flow and sends an email to the user's registered email address.
  /// If the email is successfully sent, a dialog will be displayed to inform the user about the password reset request..

  /// Displays a dialog to inform the user that a password reset email has been sent.
  /// This method shows an alert dialog to the user indicating that a password reset email has been sent to their registered email address.
  /// The dialog includes a button for the user to dismiss the dialog.
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Alterar Password'),
          content: const Text(
              "Foi enviado para o seu Email o pedido de alteração de password."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 14, 71, 116),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Builds the settings page UI.
  ///
  /// This method constructs the UI for the settings page. It returns a [Scaffold] widget with a [SingleChildScrollView]
  /// as its body, containing various settings options and actions.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 71, 116),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top:
                      20.0), // Adjust the height between the app bar and the Settings Image
              child: Container(
                height: 100, // Adjust the height as desired
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                      10), // Adjust the border radius as desired
                ),
                child: ClipRRect(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/126/126472.png', // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Geral',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Versão v1.0',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Idioma',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Português PT-PT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Definições Gerais',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  ListTile(
                    title: const Text('Poupança de Energia',
                        style: TextStyle(color: Colors.white)),
                    leading: const Icon(Icons.energy_savings_leaf,
                        color: Colors.white),
                    onTap: () {
                      //TODO
                    },
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Definições de Conta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                 
                  const SizedBox(height: 24),
                  // Add more settings as desired
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
