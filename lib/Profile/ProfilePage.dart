import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
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

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController familyCodeController;

  bool _obscureText = true;

  @override
  void initState() {
    getInfo();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    familyCodeController = TextEditingController();

    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });
    user = await db.getLoginUser();
    houseName = user.casa.split(":")[1];
    houseAdm = user.casa.split(":")[0];

    List<User> fam = await db.getFamily(user.casa);
    print("FAMILIA: $fam");
    //fam.remove(user);
    fam.removeWhere((member) => member.username == user.username);
    family = fam;
    print(family);

    setState(() {
      isLoading = false;
    });
  }

  String generateRandomString() {
    const length = 20;
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

void _showAddRoomDialog() {
  familyCodeController.text = generateRandomString();
  _obscureText = true;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Add Member',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.teal),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: const TextField(
                        cursorColor: Color(0xFF153043),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF153043),
                            ),
                          ),
                          suffixIcon:
                              Icon(Icons.person, color: Color(0xFF153043)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Center(child: Text("OR")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                      child: const TextField(
                        cursorColor: Color(0xFF153043),
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Username',
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF153043),
                            ),
                          ),
                          suffixIcon:
                              Icon(Icons.person, color: Color(0xFF153043)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text(
                        'Invite',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Center(child: Text("OR")),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: TextField(
                        controller: familyCodeController,
                        cursorColor: const Color(0xFF181116),
                        readOnly: true,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Family Code',
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF153043)),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF153043),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy,
                                    color: Color(0xFF153043)),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: familyCodeController.text,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Family Code copied!"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.username,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${user.email}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Family Members:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      onPressed: _showAddRoomDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20),
                      ),
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
