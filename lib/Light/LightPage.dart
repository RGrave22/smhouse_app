import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smhouse_app/HomePage.dart';
import 'package:smhouse_app/Light/LightPage.dart';
import 'package:smhouse_app/Register/RegisterPage.dart';
import 'package:smhouse_app/RoomPage/RoomPage.dart';
import 'package:smhouse_app/main.dart';
import 'package:smhouse_app/Data/Light.dart';
// import 'package:smhouse_app/Data/User.dart';
// import 'package:smhouse_app/Data/Division.dart';

import '../DB/DB.dart';
import '../Data/Device.dart';
import '../Data/Division.dart';
import '../Profile/ProfilePage.dart';

class LightPage extends StatefulWidget {
  final String lightName;

  const LightPage({super.key, required this.lightName});

  @override
  State<LightPage> createState() => _LightPageState();
}

class _LightPageState extends State<LightPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _lightNameController = TextEditingController();
  final LocalDB db = LocalDB('SmHouse');

  bool isLoading = true;

  late Division div;
  late Light light;
  late double currentIntensity;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });

    light = await db.getLight(widget.lightName);
    currentIntensity = light.intensity.toDouble();

    div = await db.getDivision(light.divName);

    setState(() {
      isLoading = false;
    });
  }


  String getLightColor() {
    return light.color;
  }

  void setLightColor(String newColor){
    light.color = newColor;
  }

  String getLightColorAsset() {
    if (light.color != "") {
      return 'assets/Lamp_${light.color}.png';
    } else {
      return 'assets/Lamp_yellow.png';
    }
  }

  String getDivName() {
    return light.divName.split(":")[2];
  }

  void _changeColor(String newColor) async {
    await db.updateLightColor(light.lightName, newColor);
    setState(() {
      setLightColor(newColor);
    });
  }

  Future<void> _updateIntensity(double newIntensity) async {
    await db.updateLightIntensity(light.lightName, newIntensity.toInt());
    setState(() {
      currentIntensity = newIntensity;
      light.intensity = newIntensity.toInt(); // Update local state
    });
    print(light);
  }

  void _turnOnOrOff() async {
    int newIsOn = (light.isOn == 1) ? 0 : 1;
    Device updatedDevice = Device(
      devName: light.lightName,
      isOn: newIsOn, type: 'light', divName: light.divName, houseName: light.houseName,
    );
    light = Light(lightName: light.lightName, houseName: light.houseName, divName: light.divName, isOn: newIsOn, color: "", intensity: 0);
    print(light.isOn.toString());
    
    await db.updateDeviceStatus(updatedDevice, newIsOn);

    setState(() {
        light.isOn = newIsOn;
    });

  }

  void _showEditDialog() {
    _lightNameController.text = light.lightName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Light Name'),
          content: TextField(
            controller: _lightNameController,
            decoration: const InputDecoration(
              labelText: 'Light Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String newName = _lightNameController.text;
                  Device updatedDevice = Device(
                    devName: light.lightName,
                    isOn: light.isOn, type: 'light', divName: light.divName, houseName: light.houseName,
                  );
                  light = Light(
                    lightName: newName,
                    houseName: light.houseName, divName: light.divName, isOn: light.isOn, color: light.color, intensity: light.intensity
                  );
                  db.updateDeviceName(updatedDevice, newName);
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  String divName = light.divName;

                  Device updatedDevice = Device(
                    devName: light.lightName,
                    isOn: light.isOn, type: 'light', divName: light.divName, houseName: light.houseName,
                  );

                  db.deleteDevice(updatedDevice);
                  Navigator.pop(
                    context,
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomPage(divName: divName),
                    ),
                  );
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
       appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          iconSize: 50,
          onPressed: () {
            Navigator.pop(
              context,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RoomPage(divName: light.divName),
              ),
            );
          },
        ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              icon: const Icon(Icons.account_circle, color: Colors.teal),
              iconSize: 50,
            ),
          ],
          
        ),

      body:
      isLoading
          ? const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                getDivName(),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    light.lightName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showEditDialog, // Call the function to open the popup
                  ),
                ]
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor:  Colors.teal,
                  inactiveTrackColor: Colors.teal.withOpacity(0.3),
                  thumbColor: Colors.teal,
                  overlayColor: Colors.teal.withOpacity(0.2),
                  trackHeight: 4.0,
                  valueIndicatorColor: Colors.teal,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: currentIntensity,
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${currentIntensity.toInt()}',
                  onChanged: (value) {
                    _updateIntensity(value);
                  },
                ),
              ),
            ),
            (light.isOn != 0)
                ? Center(
                child: Image.asset(
                    getLightColorAsset(), height: 322, width: 322)
            )
                : Center(
                child: Image.asset('assets/Lamp_off.png', height: 322, width: 322)
            ),
            const SizedBox(height: 7),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                ElevatedButton(
                  onPressed: () {
                    _changeColor('red');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    // side: getColorBorder(Colors.red, Color(0xff63afC0))
                  ),
                  child: const Text(" "),
                ),
                ElevatedButton(
                  onPressed: () {
                    _changeColor('yellow');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    // side: getColorBorder(Colors.red, Color(0xff63afC0))
                  ),
                  child: const Text(" "),
                ),
                ElevatedButton(
                  onPressed: () {
                    _changeColor('green');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    // side: getColorBorder(Colors.red, Color(0xff63afC0))
                  ),
                  child: const Text(" "),
                ),
                ElevatedButton(
                  onPressed: () {
                    _changeColor('blue');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    // side: getColorBorder(Colors.red, Color(0xff63afC0))
                  ),
                  child: const Text(" "),
                ),
                ElevatedButton(
                  onPressed: () {
                    _changeColor('purple');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    // side: getColorBorder(Colors.red, Color(0xff63afC0))
                  ),
                  child: const Text(" "),
                ),
              ],
              )
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _turnOnOrOff();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  side: BorderSide(
                    color: light.isOn == 1 ? Colors.green : Colors.grey, // Green if AC is ON, grey if OFF
                    width: 3, // You can adjust the width as needed
                  ),
                ),
                child: const Icon(
                  Icons.power_settings_new,
                  color: Colors.teal,
                  size: 50.0,
                ),
              ),
            )
            // const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // BorderSide getColorBorder(Color red, Color color) {
  //
  // }
}