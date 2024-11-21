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
  late int hoursTimer = 0;
  late int minutesTimer = 0;
  late int isOn = 0;
  late String devName = "";

  int? selectedHours;
  int? selectedMinutes;

  @override
  void initState() {
    getInfo();
    // setTimers();
    super.initState();
  }

  // void setTimers() {
  //   selectedHours = hoursTimer;
  //   selectedMinutes = minutesTimer;
  // }

  void getInfo() async {
    setState(() {
      isLoading = true;
    });

    ac = await db.getAC(widget.acName);
    print("AC QUE ENTRA NA PAGINA: $ac");

    div = await db.getDivision(ac.divName);

    currentAirDirection = ac.airDirection;
    temperature = ac.acTemp;
    acMode = ac.acMode;
    hoursTimer = ac.acHoursTimer;
    minutesTimer = ac.acMinutesTimer;
    isOn = ac.isOn;
    selectedHours = hoursTimer;
    selectedMinutes = minutesTimer;
    isSwingMode = ac.swingModeOn == 1;
    devName = ac.acName;

    /*if(ac.swingModeOn == 1){
      print("TAMOS A MUDAR O SWING MODE");
      setState(() {
        isSwingMode = ac.swingModeOn == 1;
      });

    }else{
      isSwingMode = false;
    }*/
    
    setState(() {
      isLoading = false;
    });
  }

  String getDivName() {
    return ac.divName.split(":")[2];
  }

  bool isAcOn(){
    return isOn == 1;
  }

  void _showEditDialog() {
    _acNameController.text = ac.acName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit AC Name'),
          content: TextField(
            controller: _acNameController,
            decoration: const InputDecoration(
              labelText: 'AC Name',
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
                    isOn: ac.isOn, type: 'ac', divName: ac.divName, houseName: ac.houseName,
                  );
                  db.updateDeviceName(updatedDevice, newName);

                  updateDeviceName( _acNameController.text);
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

  void updateDeviceName(String newName) async {
    ac = AC(acName: newName, houseName: ac.houseName, divName: ac.divName, isOn: ac.isOn,
              acMode: ac.acMode, acHoursTimer: ac.acHoursTimer, acMinutesTimer: ac.acMinutesTimer,
                swingModeOn: ac.swingModeOn, airDirection: ac.airDirection, acTemp: ac.acTemp);

    setState(() {
       devName = newName;
       currentAirDirection = ac.airDirection;
       temperature = ac.acTemp;
       acMode = ac.acMode;
       hoursTimer = ac.acHoursTimer;
       minutesTimer = ac.acMinutesTimer;
       isOn = ac.isOn;
       selectedHours = hoursTimer;
       selectedMinutes = minutesTimer;
       isSwingMode = ac.swingModeOn == 1;
       devName = ac.acName;
    });
  }

  void updateAirDirection(int newDirection) async {
    setState(() {
      currentAirDirection = newDirection;
    });
    // Update the air direction in the database
    ac.airDirection = newDirection;
    print(ac);
    await db.updateACAirDirection(ac.acName, newDirection);
  }

  void updateTemp(int newTemp, bool isUp) async {
    if(isUp){
      setState(() {
        if (temperature < 30) {
          temperature++;
          db.updateTemperature(temperature, ac);
        }
      });
    }else{
      setState(() {
        if (temperature > 0){
          temperature--;
          db.updateTemperature(temperature, ac);
        }
      });
    }
  }

  void _turnOnOrOff() async {
    int newIsOn = (ac.isOn == 1) ? 0 : 1;
    Device updatedDevice = Device(
      devName: ac.acName,
      isOn: newIsOn, type: 'ac', divName: ac.divName, houseName: ac.houseName,
    );
    ac = AC(acName: ac.acName, houseName: ac.houseName, divName: ac.divName, isOn: newIsOn, acMode: acMode, acHoursTimer: 0, acMinutesTimer: 0, swingModeOn: isSwingMode ? 1 : 0, airDirection: currentAirDirection, acTemp: temperature);
    print(ac.isOn.toString());

    await db.updateDeviceStatus(updatedDevice, newIsOn);

   setState(() {
      isOn = newIsOn;
   });
  }

  void _updateACMode(String newMode) async {
    ac.acMode = newMode;
    print(ac.acMode);

    await db.updateACMode(ac.acName, newMode);

    setState(() {
      acMode = newMode;
    });
  }

  void _updateNewTimer(int hours, int min){
    setState(() {
      hoursTimer = hours;
      minutesTimer = min;
    });
  }

  void _updateSwingMode(bool value) async {
    setState(() {
      isSwingMode = value;
      ac.swingModeOn = value ? 1 : 0;

      //if (isSwingMode) {
      //  currentAirDirection = 120; // Set to full range
      //  ac.airDirection = 120;
      //}
    });
    print(ac);
    await db.updateACSwingMode(ac, value);
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
          : SingleChildScrollView(
      child: Padding(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    devName,
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
                    GestureDetector(
                      onTap: () {
                        if(isAcOn()){
                          updateTemp(temperature, true);
                        }
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
                        if(isAcOn()) {
                          updateTemp(temperature, false);
                        }
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
                          progressBarColor: isSwingMode ? Colors.grey : Colors.teal,
                          dotColor: isSwingMode ? Colors.grey : Colors.teal,
                        ),
                        customWidths: CustomSliderWidths(
                          trackWidth: 5,
                          progressBarWidth: 7,
                          handlerSize: 10,
                        ),
                      ),
                      onChange: isSwingMode || !isAcOn()
                          ? null
                          : (value) {
                        // setState(() {
                        //   currentAirDirection = value.toInt();
                        // });
                        updateAirDirection(value.toInt());


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
                              if(isAcOn()){
                                isSwingMode = value;
                                ac.swingModeOn = value ? 1 : 0;
                              }
                              //if (isSwingMode) {
                              //  currentAirDirection = 120; // Set to full range
                              //  ac.airDirection = 120;
                              //}
                            });
                            if(isAcOn()){
                              _updateSwingMode(value);
                            }
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if(isAcOn()){
                        _showModeDialog();
                      }
                    },
                    child: Card(
                      color: Colors.teal.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'AC Mode',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              acMode, // Display the current mode
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if(isAcOn()){
                        _showTimerDialog(context);
                      }
                    },
                    child: Card(
                      color: Colors.teal.shade100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Timer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(

                              ((hoursTimer == 0) && (minutesTimer == 0)) ? 'No Timer Set' : '${hoursTimer ?? 0}h${minutesTimer ?? 0}m',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _turnOnOrOff();
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  side: BorderSide(
                    color: isOn == 1 ? Colors.green : Colors.grey,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.power_settings_new,
                  color: Colors.teal,
                  size: 50.0,
                ),
              ),
            )
        ]
        ),
      ),
    ));
  }

  void _showModeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select AC Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.ac_unit, color: Colors.teal),
                title: const Text('Cool'),
                onTap: () {
                  _updateACMode('Cool');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_fire_department, color: Colors.teal),
                title: const Text('Heat'),
                onTap: () {
                  _updateACMode('Heat');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.air, color: Colors.teal),
                title: const Text('Fan'),
                onTap: () {
                  _updateACMode('Fan');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.opacity, color: Colors.teal),
                title: const Text('Dry'),
                onTap: () {
                  _updateACMode('Dry');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimerDialog(BuildContext context1) {
    int currHoursTimer = hoursTimer;
    int currMinutesTimer = minutesTimer;

    List<DropdownMenuItem<int>> hoursItems = [
      for (int i = 0; i < 24; i++)
        DropdownMenuItem<int>(
          value: i,
          child: Text('$i hours'),
        ),
    ];

    List<DropdownMenuItem<int>> minutesItems = [
      for (int i = 0; i < 60; i++)
        DropdownMenuItem<int>(
          value: i,
          child: Text('$i minutes'),
        ),
    ];

    showDialog(
      context: context1,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Set Timer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<int>(
                        value: currHoursTimer,
                        items: hoursItems,
                        onChanged: (int? newValue) {
                          setState(() {
                            currHoursTimer = newValue ?? 0;
                            print('Selected Hours: $currHoursTimer');
                          });
                        },
                      ),
                      DropdownButton<int>(
                        value: currMinutesTimer,
                        items: minutesItems,
                        onChanged: (int? newValue) {
                          setState(() {
                            currMinutesTimer = newValue ?? 0;
                            print('Selected Minutes: $currMinutesTimer');
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      //currHoursTimer = 0;
                      //currMinutesTimer = 0;
                      ac.acHoursTimer = 0;
                      ac.acMinutesTimer = 0;
                      hoursTimer = 0;
                      minutesTimer = 0;
                    });
                    _updateNewTimer(0,0);
                    db.updateACTimer(ac.acName, ac.acHoursTimer, ac.acMinutesTimer);
                    Navigator.pop(context);
                  },
                  child: const Text('Delete Timer'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    print(currHoursTimer);
                    setState(() {
                      ac.acHoursTimer = currHoursTimer;
                      ac.acMinutesTimer = currMinutesTimer;
                      //selectedHours = currHoursTimer;
                      //selectedMinutes = currMinutesTimer;
                      hoursTimer = currHoursTimer;
                      minutesTimer = currMinutesTimer;
                    });
                    _updateNewTimer(currHoursTimer,currMinutesTimer);
                    print('Timer Set: ${ac.acHoursTimer} hours, ${ac.acMinutesTimer} minutes');
                    db.updateACTimer(ac.acName, ac.acHoursTimer, ac.acMinutesTimer);
                    Navigator.pop(context);
                  },
                  child: const Text('Set'),
                ),
              ],
            );
          },
        );
      },
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