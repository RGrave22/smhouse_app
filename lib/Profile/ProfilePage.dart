import 'package:flutter/material.dart';

import '../DB/DB.dart';
import '../Data/User.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}


class _ProfilePage extends State<ProfilePage> {
  final LocalDB db = LocalDB('SmHouse');
  late User user;
  List<User> family = [];
  bool isLoading = true;
  late String houseName;
  late String houseAdm;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });
    user = await db.getLoginUser();
    houseName = user.casa.split(":")[1];
    houseAdm = user.casa.split(":")[0];

    List <User> fam = await db.getFamily(user.casa);
    print("FAMILIA: $fam");
    //fam.remove(user);
    fam.removeWhere((member) => member.username == user.username);
    family = fam;
    print(family);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
      ),
    )
        :Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/Logo_init.jpeg', height: 50),
        backgroundColor: Colors.white,
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
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:
        Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
            SizedBox(height: 16),

            // User Name
            Text(
              user.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            // User Information (Email and Birthday)
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),


            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Family Members:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: family.length,
                itemBuilder: (context, index) {
                  final member = family[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(member.username),
                      //subtitle: Text(member.username == houseAdm ? 'House Administrator' : '',)
                      //subtitle: Text(member['relation']!),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                ),
                onPressed: () {  },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

}