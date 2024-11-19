import 'package:flutter/material.dart';
import 'package:smhouse_app/Profile/ProfilePage.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "About Us",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 120,
              height: 4,
              color: Colors.teal,
            ),
            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "SmHouse is an app designed for families who want to control their homes at the distance of a few clicks. Here they can control all the smart devices available at their home, from lights to blinds. Developing SmHouse, we focused on the interaction between the app and the user, providing a simple and minimalist interface so that anyone can use it to control all the devices available at home.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Developers",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              width: 100,
              height: 3,
              color: Colors.teal.shade300,
            ),
            const SizedBox(height: 20),

            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildDeveloperCard(
                  "assets/RodrigoGrave.jpg",
                  "Rodrigo Grave",
                  "60532",
                ),
                _buildDeveloperCard(
                  "assets/GonçaloMateus.jpg",
                  "Gonçalo Mateus",
                  "60333",
                ),
                _buildDeveloperCard(
                  "assets/EduardoSilveiro.jpg",
                  "Eduardo Silveiro",
                  "72287",
                ),
                _buildDeveloperCard(
                  "assets/DiogoMatos.jpg",
                  "Diogo Matos",
                  "70252",
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }

  Widget _buildDeveloperCard(String imagePath, String name, String id) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 10),

        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),

        Text(
          id,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
