import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../DB/DB.dart';
import '../Data/Device.dart';
import '../Data/Division.dart';
import '../Data/Ac.dart';
import '../Profile/ProfilePage.dart';
import '../RoomPage/RoomPage.dart';

class AcPage extends StatefulWidget {
  final String acName;

  const AcPage({super.key, required this.acName});

  @override
  State<AcPage> createState() => AcPageState();
}


class AcPageState extends State<AcPage> {
  final LocalDB db = LocalDB('SmHouse');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _acNameController = TextEditingController();

  bool isLoading = true;

  late Division div;
  late AC ac;

  late int currentAirDirection = 0;
  late int temperature = 0;
  late bool isSwingMode = false;
  late String acMode = "Cool";
  late String timer = "";

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });

    ac = await db.getAC(widget.acName);

    div = await db.getDivision(ac.divName);

    currentAirDirection = ac.airDirection;
    temperature = ac.acTemp;
    acMode = ac.acMode;
    timer = ac.acTimer;

    if(ac.swingModeOn== 1){
      isSwingMode = true;
    }else{
      isSwingMode = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  String getDivName() {
    return ac.divName.split(":")[2];
  }

  void _showEditDialog() {
    _acNameController.text = ac.acName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Light Name'),
          content: TextField(
            controller: _acNameController,
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
                  String newName = _acNameController.text;
                  Device updatedDevice = Device(
                    devName: ac.acName,
                    isOn: ac.isOn, type: 'light', divName: ac.divName, houseName: ac.houseName,
                  );
                  db.updateDeviceName(updatedDevice, newName);
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void updateAirDirection(int newDirection) async {
    setState(() {
      currentAirDirection = newDirection;
    });

    // Update the air direction in the database
    //ac.airDirection = newDirection;
    //await db.updateACAirDirection(ac.acName, newDirection);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.teal),
          iconSize: 50,
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RoomPage(divName: ac.divName),
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
      body: isLoading
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
            //const SizedBox(height: 20),
            Center(
              child: Text(
                getDivName(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    ac.acName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _showEditDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Upward Triangle Button (Increase Temperature)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (temperature < 30) temperature++;
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
                      'Temperature \n${temperature.toInt()}°',
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
                          if (temperature >= 0) temperature--;
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
                const SizedBox(width: 70),
                Column(
                  children: [
                    const SizedBox(height: 50,),
                    SleekCircularSlider(
                      min: 0,
                      max: 120,
                      initialValue: currentAirDirection.toDouble(),
                      appearance: CircularSliderAppearance(
                        size: 150,
                        angleRange: 150,
                        startAngle: 105,
                        customColors: CustomSliderColors(
                          trackColor: Colors.grey.shade300,
                          progressBarColor: Colors.teal,
                          dotColor: Colors.teal,
                        ),
                        customWidths: CustomSliderWidths(
                          trackWidth: 5,
                          progressBarWidth: 7,
                          handlerSize: 10,
                        ),
                      ),
                      onChange: isSwingMode
                          ? null
                          : (value) {
                        setState(() {
                          currentAirDirection = value.toInt();
                        });
                      },
                      innerWidget: (value) => Center(
                        child: Text(
                          'Spans angle \n${value.toInt()}°',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Text('Swing Mode', style: TextStyle(fontWeight: FontWeight.bold),),
                        Switch(
                          value: isSwingMode,
                          onChanged: (bool value) {
                            setState(() {
                              isSwingMode = value;
                              // If swing mode is enabled, set angle to full and disable the slider
                              if (isSwingMode) {
                                currentAirDirection = 120; // Set to full range
                              }
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
                //const SizedBox(height: 50),
              ],
            ),
          ),
            const SizedBox(height: 50),
            // Bottom Buttons: AC Mode and Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for setting the AC mode
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.teal,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('AC Mode'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Action for setting the timer
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.teal,
                      textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Set Timer'),
                  ),
                ),
              ],
            ),
        ]
        ),
      ),
    );
  }

}

class TrianglePainter extends CustomPainter {
  final bool isUpward;
  final Color color;

  TrianglePainter({required this.isUpward, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    if (isUpward) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}