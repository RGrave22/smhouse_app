import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smhouse_app/HomePage.dart';
import 'package:smhouse_app/Login/LoginPage.dart';
import 'package:smhouse_app/Profile/ProfilePage.dart';

/// A page for managing user settings.
class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {


  /// Builds the settings page UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          iconSize: 50,
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
            icon: const Icon(Icons.account_circle, color: Colors.teal),
            iconSize: 50,
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                  color: const Color.fromARGB(255, 255, 255, 255),
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
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Versão v1.0',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Idioma',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Português PT-PT',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Definições Gerais',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),


                  ListTile(
                    title: const Text('Poupança de Energia',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    leading: const Icon(Icons.energy_savings_leaf,
                        color: Colors.black),
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
                      color: Colors.black,
                    ),
                  ),

                  ListTile(
                    title: const Text('Trocar Password',
                        style: TextStyle(color: Colors.black)),
                    leading: const Icon(Icons.lock, color: Colors.black),
                    onTap: () {
                      //_changePassword(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Sair da Conta',
                        style: TextStyle(color: Colors.black)),
                    leading: const Icon(Icons.logout, color: Colors.black),
                    onTap: () {
                      
                    }
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