import 'package:flutter/material.dart';
import 'package:smhouse_app/FamilyMember/FamilyMemberPermissions.dart';
import 'package:smhouse_app/HomePage.dart';
import 'package:smhouse_app/Profile/ProfilePage.dart';

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
  bool isLoading = true;
  late User user;

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

  Future<void> removeFromHouse(String username) async {
    await db.updateUserHouse(username);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.teal),
                iconSize: 50,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Confirm Delete',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.teal),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                          content: const Text(
                              'Are you sure you want to remove this user from your family group?'),
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                removeFromHouse(memberName);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProfilePage(),
                                  ),
                                );
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.teal),
                  iconSize: 50,
                ),
              ],
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    memberName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Member's information",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email: ${memberMail}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Family Member's Settings:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.all(20),
                          ),
                          onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FamilyMemberPermissions(
                                              familyMember:
                                                  widget.familyMember)),
                                )
                              },
                          child: Text("${memberName}'s Permissions",
                              style: const TextStyle(color: Colors.white))),
                    ),
                  ]),
                ],
              ),
            ),
          );
  }
}
