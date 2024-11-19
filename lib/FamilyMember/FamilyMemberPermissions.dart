import 'package:flutter/material.dart';
import 'package:smhouse_app/Data/DivRestriction.dart';
import 'package:smhouse_app/Data/Division.dart';

import '../DB/DB.dart';
import '../Data/User.dart';

class FamilyMemberPermissions extends StatefulWidget {
  final User familyMember;

  const FamilyMemberPermissions({super.key, required this.familyMember});

  @override
  State<FamilyMemberPermissions> createState() => _FamilyMemberPermissions();
}


class _FamilyMemberPermissions extends State<FamilyMemberPermissions> {
  final LocalDB db = LocalDB('SmHouse');
  late User user;
  late String memberName;
  late String memberMail;
  late List<DivRestriction> restrictedDivs;
  late List<Division> divs;
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
    user = await db.getLoginUser();
    memberName = widget.familyMember.username;
    memberMail = widget.familyMember.email;
    restrictedDivs = await db.getUserRestrictedDivs(memberName);
    divs = await db.getDivisions(user.casa);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateRestrictedDivsList() async{
    restrictedDivs = await db.getUserRestrictedDivs(memberName);
  }

  bool checkRestricted(Division div){
    for(DivRestriction rd in restrictedDivs){
      if(div.divName.split(":")[2] == rd.divName) {
        return true;
      }
    }
    return false;
  }

  void onDivRestrictionChange(String divName, bool value) async{
      setState(() {
        if (value) {
          restrictedDivs.add(DivRestriction(
            restrictionName: "$memberName:$divName",
            username: memberName,
            divName: divName,
          ));
        } else {
          restrictedDivs.removeWhere((div) => div.divName == divName);
        }
      });

      await db.updateDivRestriction(divName, memberName, value);
      await updateRestrictedDivsList();

      setState(() {});
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
            const Text(
              "Permissions",
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // User Name
            Text(
              memberName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              "(grau de parentesco)",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 16),

            const SizedBox(height: 8),

            // User Information (Email and Birthday)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Prohibited Rooms",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: divs.length,
                  itemBuilder: (context, index) {
                    final div = divs[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black12),
                      ),
                      child: ListTile(
                        title: Text(div.divName.split(":")[2]),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: checkRestricted(div),
                              onChanged: (value){
                                setState(() {
                                  onDivRestrictionChange(div.divName.split(":")[2], value);
                                });
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.grey,
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    );
                  }
                ),
            ),
          ],
        ),
      ),

    );
  }

}