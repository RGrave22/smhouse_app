

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smhouse_app/Data/VirtualAssist.dart';

import '../DB/DB.dart';
import '../Data/Device.dart';
import '../Data/Division.dart';
import '../Profile/ProfilePage.dart';
import '../RoomPage/RoomPage.dart';

class VirtualAssistPage extends StatefulWidget {
  final String vaName;

  const VirtualAssistPage({super.key, required this.vaName});

  @override
  State<VirtualAssistPage> createState() => VirtualAssistPageState();
}

class VirtualAssistPageState extends State<VirtualAssistPage> {
  final LocalDB db = LocalDB('SmHouse');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _vaNameController = TextEditingController();
  bool isLoading = true;
  List<String> musicList = ['High_Hopes', 'Sultans_of_Swing', "The_Piper's_Call", 'Learning_to_Fly']; // Static music list
  int currentMusicIndex = -1;

  late VirtualAssist va;
  late Division div;
  late int alarmHours = 0;
  late int alarmMinutes = 0;
  late int isOn = 0;
  late String devName = "";
  late String divName = "";
  late int volume = 0;
  late int isPlaying = 0;
  late bool isMuted = false;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  void getInfo() async {
    setState(() {
      isLoading = true;
    });

    va = await db.getVa(widget.vaName);
    print("VA QUE ENTRA NA PAGINA: $va");

    div = await db.getDivision(va.divName);

    alarmHours = va.alarmHours;
    alarmMinutes = va.alarmMinutes;
    isOn = va.isOn;
    devName = va.vaName;
    volume = va.volume;
    isPlaying = va.isPlaying;
    if(va.music != ""){
      currentMusicIndex = musicList.indexOf(va.music);
      print(currentMusicIndex);
    }
    isMuted = va.isMuted == 1;

    setState(() {
      isLoading = false;
    });
  }

  String getDivName() {
    return va.divName.split(":")[2];
  }

  bool isVaOn(){
    return isOn == 1;
  }

  void _nextMusic() {
    if(isVaOn()) {
      setState(() {
        currentMusicIndex = (currentMusicIndex + 1) % musicList.length;
        va.music = musicList[currentMusicIndex];
        if (isPlaying == 0) {
          isPlaying = 1;
          va.isPlaying = isPlaying;
          db.updateVaPlayingStatus(va.vaName, isPlaying);
        }
        db.updateVaMusic(va.vaName, va.music);
      });
    }
  }

  void _previousMusic() {
    if(isVaOn()) {
      setState(() {
        currentMusicIndex =
            (currentMusicIndex - 1 + musicList.length) % musicList.length;
        va.music = musicList[currentMusicIndex];
        if (isPlaying == 0) {
          isPlaying = 1;
          va.isPlaying = isPlaying;
          db.updateVaPlayingStatus(va.vaName, isPlaying);
        }
        db.updateVaMusic(va.vaName, va.music);
      });
    }
  }

  void _togglePlayPause() {
    if(isVaOn()) {
      setState(() {
        if (va.music.isEmpty) {
          currentMusicIndex = 0; // Start with the first music in the list
          va.music = musicList[currentMusicIndex];
          db.updateVaMusic(va.vaName, va.music);
        }

        isPlaying = isPlaying == 1 ? 0 : 1;
        va.isPlaying = isPlaying;

        db.updateVaPlayingStatus(va.vaName, isPlaying);
      });
    }
  }

  void _showEditDialog() {
    _vaNameController.text = va.vaName;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit AC Name'),
          content: TextField(
            controller: _vaNameController,
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
                  String newName = _vaNameController.text;
                  Device updatedDevice = Device(
                    devName: va.vaName,
                    isOn: va.isOn, type: 'virtualAssist', divName: va.divName, houseName: va.houseName,
                  );
                  db.updateDeviceName(updatedDevice, newName);
                  updateDeviceName( _vaNameController.text);
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
    setState(() {
      devName = newName;
    });
  }

  Future<void> _updateVolume(double newVolume) async {
    await db.updateVaVolume(va.vaName, newVolume.toInt());
    setState(() {
      volume = newVolume.toInt();
      va.volume = newVolume.toInt(); // Update local state
    });
    print(va);
  }

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
                  builder: (context) => RoomPage(divName: va.divName),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.volume_up,
                          size: 30.0,
                          color: Colors.teal,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child:
                        SliderTheme(
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
                            value: volume.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 50,
                            label: '${volume.toInt()}',
                            onChanged: (value) {
                              if(isVaOn()) {
                                _updateVolume(value);
                              }
                            },
                          ),
                        ),),
                      ],
                    ),
                  ),
                  Center(
                    child: va.music.isEmpty
                        ? Container(
                      height: 250,
                      width: 250,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade300,
                      ),
                      child: const Text(
                        'No music playing',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.teal.shade100,
                            image: DecorationImage(
                              image: AssetImage('assets/${va.music}.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          va.music.replaceAll('_', ' '),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 40, color: Colors.teal),
                        onPressed: _previousMusic,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying == 1 ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          size: 60,
                          color: Colors.teal,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 40, color: Colors.teal),
                        onPressed: _nextMusic,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (isVaOn()) {
                              setState(() {
                                va.isMuted = va.isMuted == 1 ? 0 : 1;
                                isMuted = va.isMuted == 1;

                                db.updateVaMuteStatus(va.vaName, va.isMuted);
                              });
                            }
                          },
                          child: Card(
                            color: Colors.teal.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    va.isMuted == 1 ? Icons.mic_off : Icons.mic,
                                    size: 35.0,
                                    color: Colors.teal.shade900,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    va.isMuted == 1 ? 'Muted' : 'Unmuted',
                                    style: TextStyle(
                                      fontSize: 18,
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
                            if (isVaOn()) {
                              _showAlarmDialog(context);
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
                                    'Alarm',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade900,
                                    ),
                                  ),
                                  const SizedBox(height: 17,),
                                  Text(
                                    ((alarmHours == 0) && (alarmMinutes == 0))
                                        ? 'No Alarm Set'
                                        : '${(alarmHours ?? 0).toString().padLeft(2, '0')}:${(alarmMinutes ?? 0).toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 18,
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
                  const SizedBox(height: 10),
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

  void _turnOnOrOff() async {
    int newIsOn = (va.isOn == 1) ? 0 : 1;
    Device updatedDevice = Device(
      devName: va.vaName,
      isOn: newIsOn, type: 'virtualAssist', divName: va.divName, houseName: va.houseName,
    );
    va = VirtualAssist(vaName: va.vaName, houseName: va.houseName, divName: va.divName, isOn: newIsOn, volume: va.volume, isPlaying: va.isPlaying, music: va.music, isMuted: va.isMuted, alarmHours: va.alarmHours, alarmMinutes: va.alarmMinutes);
    print(va.isOn.toString());

    await db.updateDeviceStatus(updatedDevice, newIsOn);

    setState(() {
      isOn = newIsOn;
      if(isPlaying == 1 && newIsOn == 0){
        isPlaying = 0;
        va.isPlaying = isPlaying;
        db.updateVaPlayingStatus(va.vaName, isPlaying);
      }
    });
  }

  void _showAlarmDialog(BuildContext context1) {
    int currHoursTimer = alarmHours;
    int currMinutesTimer = alarmMinutes;

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
              title: const Text('Set Alarm'),
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
                      va.alarmHours = 0;
                      va.alarmMinutes = 0;
                      alarmHours = 0;
                      alarmMinutes = 0;
                    });
                    _updateNewAlarm(0,0);
                    db.updateACTimer(va.vaName, va.alarmHours, va.alarmMinutes);
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
                      va.alarmHours = currHoursTimer;
                      va.alarmMinutes = currMinutesTimer;
                      //selectedHours = currHoursTimer;
                      //selectedMinutes = currMinutesTimer;
                      alarmHours = currHoursTimer;
                      alarmMinutes = currMinutesTimer;
                    });
                    _updateNewAlarm(currHoursTimer,currMinutesTimer);
                    //print('Timer Set: ${ac.acHoursTimer} hours, ${ac.acMinutesTimer} minutes');
                    db.updateVaAlarm(va.vaName, va.alarmHours, va.alarmMinutes);
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

  void _updateNewAlarm(int hours, int min){
    setState(() {
      alarmHours = hours;
      alarmMinutes = min;
    });
  }




}