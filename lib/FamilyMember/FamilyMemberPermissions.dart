import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:smhouse_app/Data/Device.dart';
import 'package:smhouse_app/Data/DivRestriction.dart';
import 'package:smhouse_app/Data/Division.dart';

import '../AC/ACPage.dart';
import '../DB/DB.dart';
import '../Data/DevRestriction.dart';
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
  late List<DevRestriction> restrictedDevs;
  late List<Division> divs;
  late List<Device> devs;
  //late String memberBirthday;
  bool isLoading = true;

  //restriced device times
  late int startHour = 9;
  late int startMin = 0;
  late int endHour = 17;
  late int endMin = 0;
  late bool isAllDay = false;

  final String STARTING_TIME_CONTROLLER = "start";
  final String ENDING_TIME_CONTROLLER = "end";
  final int HOUR_LIMIT = 23;
  final int MINUTE_LIMIT = 59;

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
    restrictedDevs = await db.getUserRestrictedDevs(memberName);
    divs = await db.getDivisions(user.casa);
    devs = [];
    for(Division i in divs){
      var divDevs = await db.getDevicesOfDivision(i.divName);
      for(Device j in divDevs){
        devs.add(j);
      }
    }

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

  void callUpdateDeviceRestriction(DevRestriction dev, BuildContext context){
    for(Device d in devs){
      if(d.devName == dev.deviceName){
        return _showRestrictionHoursDialog(d, context, false);
      }
    }
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
            const SizedBox(height: 8),

            const SizedBox(height: 8),

            // User Information (Email and Birthday)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Prohibited Rooms",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            //RESTRICTED ROOMS LIST
            Expanded(
              child:Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(80),
                  borderRadius: BorderRadius.circular(10.0)
              ),
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
                        ],
                      ),
                    ),
                  );
                }
            ),
              ),
            ),

            const SizedBox(height: 8),


            Row(
              children: [const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Prohibited Devices",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.all(10),
                      ),
                      onPressed: _showChooseDevice,
                      child: const Text(
                          "Add Device Restriction",
                          style: TextStyle(color: Colors.white)
                      )
                  )
                )]
            ),


            //RESTRICTED DEVICES LIST
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(80),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListView.builder(
                    itemCount: restrictedDevs.length,
                    itemBuilder: (context, index) {
                      final dev = restrictedDevs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        child: ListTile(
                          title: Text("${dev.deviceName} (${dev.deviceRoomName.split(":")[2]})"),
                          trailing: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: () => {
                            callUpdateDeviceRestriction(dev, context)
                          },
                        ),
                      );
                    }
                ),
              )
            ),
          ],
        ),
      ),

    );
  }

  void _showChooseDevice() {
    startHour = 9;
    startMin = 0;
    endHour = 17;
    endMin = 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:Row(
            children: [
              const Expanded(child: Text(
                'Choose Prohibited Device',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.teal),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: devs.length,
                itemBuilder: (context, index) {
                  final dev = devs[index];
                  return ListTile(
                    title: Text("${dev.devName} (${dev.divName.split(":")[2]})"),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                      ],
                    ),
                    onTap: () => {
                      Navigator.pop(context),
                      _showRestrictionHoursDialog(dev, context, true)
                    },
                  );
                }

            ),
          ),

        );
      },
    );
  }

  void updateHour(bool isUp, bool isStart) {
    if (isUp) {
      if(isStart) {
        if (startHour + 1 > HOUR_LIMIT) {
          setState(() {
            startHour = 0;
          });
        } else {
          setState(() {
            startHour++;
          });
        }
      }else{
        if (endHour + 1 > HOUR_LIMIT) {
          setState(() {
            endHour = 0;
          });
        } else {
          setState(() {
            endHour++;
          });
        }
      }
    } else {
      if(isStart) {
        if (startHour - 1 < 0) {
          setState(() {
            startHour = HOUR_LIMIT;
          });
        } else {
          setState(() {
            startHour--;
          });
        }
      }else{
        if (endHour - 1 < 0) {
          setState(() {
            endHour = HOUR_LIMIT;
          });
        } else {
          setState(() {
            endHour--;
          });
        }
      }
    }
  }

  void updateMin(bool isUp, bool isStart) {
    if (isUp) {
      if(isStart){
        if (startMin + 1 > MINUTE_LIMIT) {
          setState(() {
            startMin = 0;
          });
        } else {
          setState(() {
            startMin++;
          });
        }
      }else{
        if (endMin + 1 > MINUTE_LIMIT) {
          setState(() {
            endMin = 0;
          });
        } else {
          setState(() {
            endMin++;
          });
        }
      }

    } else {
      if(isStart){
        if (startMin - 1 < 0) {
          setState(() {
            startMin = MINUTE_LIMIT;
          });
        } else {
          setState(() {
            startMin--;
          });
        }
      }else{
        if (endMin - 1 < 0) {
          setState(() {
            endMin = MINUTE_LIMIT;
          });
        } else {
          setState(() {
            endMin--;
          });
        }
      }

    }
  }


  void _showRestrictionHoursDialog(Device restrictedDev, BuildContext context1, bool isNew){

    DevRestriction dr = DevRestriction(restrictionName: "", deviceName: "", username: "", deviceRoomName: "", startingTimeHour: 0, startingTimeMinute: 0, endTimeHour: 0, endTimeMinute: 0, isAllDay: false);
    if(!isNew){
      for(DevRestriction i in restrictedDevs){
        if(i.deviceName == restrictedDev.devName){
          dr = i;
        }
      }
      startHour = dr.startingTimeHour;
      startMin = dr.startingTimeMinute;
      endHour = dr.endTimeMinute;
      endMin = dr.endTimeMinute;
      isAllDay = dr.isAllDay;
    }

    showDialog(
      context: context1,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState){
              return AlertDialog(
                title: Row(
                  children: [
                    const Expanded(child: Text(
                      'Set Prohibition Time',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.teal),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),

                content: SingleChildScrollView(
                  child: Container(
                    width: double.maxFinite,
                    child:Column(
                      children: [
                        Text(
                          "${restrictedDev.devName}\n(${restrictedDev.divName.split(":")[2]})",
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        Row(
                            children: [
                              const Text(
                                  'Restrict All Day',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16)
                              ),
                              Spacer(),
                              Switch(
                                  value: isAllDay,
                                  onChanged: (value) => {
                                    setState(()=>
                                      isAllDay = value
                                    )
                                  },
                                  activeColor: Colors.green,
                              )
                            ]
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        const Text(
                            'Set Starting Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        updateHour(true, true);
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CustomPaint(
                                        painter: TrianglePainter(isUpward: true, color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    '${startHour.toString().padLeft(2, '0')} h',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  // Downward Triangle Button (Decrease Temperature)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        updateHour(false, true);
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CustomPaint(
                                        painter: TrianglePainter(isUpward: false, color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            const SizedBox(width: 70),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateMin(true, true);
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CustomPaint(
                                      painter: TrianglePainter(isUpward: true, color: Colors.teal),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  '${startMin.toString().padLeft(2, '0')} min',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                // Downward Triangle Button (Decrease Temperature)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateMin(false, true);
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CustomPaint(
                                      painter: TrianglePainter(isUpward: false, color: Colors.teal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                            'Set Ending Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        updateHour(true, false);
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CustomPaint(
                                        painter: TrianglePainter(isUpward: true, color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(
                                    '${endHour.toString().padLeft(2, '0')} h',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  // Downward Triangle Button (Decrease Temperature)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        updateHour(false, false);
                                      });
                                    },
                                    child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CustomPaint(
                                        painter: TrianglePainter(isUpward: false, color: Colors.teal),
                                      ),
                                    ),
                                  ),
                                ]
                            ),
                            const SizedBox(width: 70),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateMin(true, false);
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CustomPaint(
                                      painter: TrianglePainter(isUpward: true, color: Colors.teal),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  '${endMin.toString().padLeft(2, '0')} min',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                // Downward Triangle Button (Decrease Temperature)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      updateMin(false, false);
                                    });
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CustomPaint(
                                      painter: TrianglePainter(isUpward: false, color: Colors.teal),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  restrictionDeleteButton(restrictedDev, !isNew, context),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () {
                      updateDeviceRestriction(restrictedDev.devName, restrictedDev.divName, isAllDay, isNew);
                      Navigator.pop(context);
                    },
                    child: const Text('Done', style: TextStyle(color: Colors.white)),
                  ),

                ],
              );
            }
        );

      },
    );
  }

  Widget restrictionDeleteButton (Device restrictedDev, bool isEditing, BuildContext context){
    if(isEditing){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          padding: const EdgeInsets.all(15),
        ),
        onPressed: () {
          Navigator.pop(context);
          deleteDeviceRestriction(restrictedDev);
        },
        child: const Text('Delete', style: TextStyle(color: Colors.white)),
      );
    }
    return const SizedBox.shrink();
  }

  void deleteDeviceRestriction(Device restrictedDev) async{
    setState(() {
      setState(() {
        restrictedDevs.removeWhere((devR) => devR.restrictionName == "$memberName:${restrictedDev.devName}");
      });
    });
    await db.deleteDevRestriction("$memberName:${restrictedDev.devName}");
    await updateRestrictedDivsList();
  }

  void updateDeviceRestriction(String devName, String devRoomName, bool allDay, bool isNew) async{
    setState(() {
      if (isNew) {
        setState(() {
          restrictedDevs.add(DevRestriction(restrictionName: "$memberName:$devName", deviceName: devName, username: memberName, deviceRoomName: devRoomName,
              startingTimeHour: startHour, startingTimeMinute: startMin, endTimeHour: endHour, endTimeMinute: endMin, isAllDay: allDay));
        });
      } else {
        setState(() {
          restrictedDevs.removeWhere((devR) => devR.restrictionName == "$memberName:$devName");
          restrictedDevs.add(DevRestriction(restrictionName: "$memberName:$devName", deviceName: devName, username: memberName, deviceRoomName: devRoomName,
              startingTimeHour: startHour, startingTimeMinute: startMin, endTimeHour: endHour, endTimeMinute: endMin, isAllDay: allDay));
        });

      }
    });
    await db.updateDevRestriction(devName, memberName, devRoomName, startHour, startMin, endHour, endMin, allDay, isNew);
    await updateRestrictedDivsList();

    setState(() {});
  }

  Row timeSetRow(String startOrEndController){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {

                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomPaint(
                    painter: TrianglePainter(isUpward: true, color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                'HH h',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10,),
              // Downward Triangle Button (Decrease Temperature)
              GestureDetector(
                onTap: () {},
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CustomPaint(
                    painter: TrianglePainter(isUpward: false, color: Colors.teal),
                  ),
                ),
              ),
            ]
        ),
        const SizedBox(width: 70),
        Column(
          children: [
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: TrianglePainter(isUpward: true, color: Colors.teal),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text(
              'MM min',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10,),
            // Downward Triangle Button (Decrease Temperature)
            GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: TrianglePainter(isUpward: false, color: Colors.teal),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}