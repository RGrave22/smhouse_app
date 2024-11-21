import 'package:flutter/material.dart';
import 'package:smhouse_app/FamilyMember/FamilyMemberPermissions.dart';

import '../DB/DB.dart';
import '../Data/User.dart';

class FamilyMemberPage extends StatefulWidget {
  final User familyMember;

  const FamilyMemberPage({super.key, required this.familyMember});

  @override
  State<FamilyMemberPage> createState() => _FamilyMemberPage();
}


class _FamilyMemberPage extends State<FamilyMemberPage> {
  final LocalDB db = LocalDB('SmHouse');
  late String memberName;
  late String memberMail;
  //late String memberBirthday;
  bool isLoading = true;


  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });
    memberName = widget.familyMember.username;
    memberMail = widget.familyMember.email;
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
            // User Name
            Text(
              memberName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              height: 175,
              width: 175,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.teal.shade100,
                image: DecorationImage(
                  image: AssetImage('assets/$memberName.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 8),

            // User Information (Email and Birthday)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Member's information",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email: ${memberMail}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),

            SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Family Member's Settings:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.teal),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      onPressed: () => {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FamilyMemberPermissions(familyMember: widget.familyMember)),
                      )},
                      child: Text(
                          "${memberName}'s permissions",
                          style: const TextStyle(color: Colors.white)
                      )
                  ),
                ),
              ]
            ),
          ],
        ),
      ),

    );
  }

}