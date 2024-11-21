import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smhouse_app/Data/DivRestriction.dart';
import 'package:smhouse_app/RoomPage/RoomPage.dart';

import 'DB/DB.dart';
import 'Data/Division.dart';
import 'Data/User.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalDB db = LocalDB('SmHouse');
  late User user;
  List<Division> rooms = [];
  bool isLoading = true;
  late List<DivRestriction> divRestrictions;


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

    rooms = await db.getDivisions(user.casa);
    divRestrictions = await db.getUserRestrictedDivs(user.username);
    setState(() {
      isLoading = false;
    });
  }

  String getHouseTemp(){
    int temp = 0;
    int nDivs = 0;
    for(Division d in rooms){
      temp = temp + int.parse(d.divTemp);
      nDivs++;
    }

    double res = temp/nDivs;
    return "${res.toStringAsFixed(0)}º";
  }

  String getDivName(String divName){
    return divName.split(":")[2];
  }

  Future<bool> addRoom(String roomName) async {
    String divName = "${user.casa}:$roomName";
    Division div = Division(divName: divName, houseName: user.casa, divON: 0, divTemp: getHouseTemp().replaceAll("º", ""));
    var result = await db.addDivision(div);
    if (result) {
      rooms.add(div);
    }
    print(rooms);
    return result;
  }

  Future<String> getDivDevicesOn(String divName) async {
    int devicesOn = await db.countDevicesOnInDivision(divName);

    return devicesOn.toString();
  }

void _showHouseTempPopup() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'House Temperature',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  for (Division room in rooms)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _getRoomIcon(getDivName(room.divName)),
                                color: Colors.teal,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                getDivName(room.divName),
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            "${room.divTemp}º",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

IconData _getRoomIcon(String roomName) {
  switch (roomName.toLowerCase()) {
    case "kitchen":
      return Icons.kitchen;
    case "bedroom":
      return Icons.bed;
    case "garage":
      return Icons.garage;
    case "office":
      return Icons.computer;
    case "living room":
      return Icons.tv_rounded;
    default:
      return Icons.home;
  }
}



  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                          'Add Room',
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
                // Lista de divisões
                _buildRoomOption(Icons.kitchen, "Kitchen"),
                _buildRoomOption(Icons.bed, "BedRoom"),
                _buildRoomOption(Icons.garage, "Garage"),
                _buildRoomOption(Icons.computer, "Office"),
                _buildRoomOption(Icons.tv_rounded, "Living Room"),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditRoomDialog(String roomType) {
  TextEditingController _roomNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Edit Room - $roomType',
                        style: const TextStyle(
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
              TextField(
                controller: _roomNameController,
                decoration: const InputDecoration(
                  labelText: 'Room Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Verifica se o campo está vazio e atribui um nome padrão
                  String roomName = _roomNameController.text.isEmpty
                      ? 'Room ${rooms.length + 1}'
                      : _roomNameController.text;
                  
                  Navigator.of(context).pop();
                  var result = await addRoom(roomName);
                  setState(() {

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Room "$roomName" created!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Room "$roomName" already exists!')),
                      );
                    }
                  });

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  Widget _buildRoomOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: const TextStyle(color: Colors.teal)),
      onTap: () {
        Navigator.of(context).pop(); 
        _showEditRoomDialog(label); 
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Center(
              child: Image.asset('assets/Logo_init.jpeg', height: 80),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherInfo("Weather", "22°"),
                    _buildWeatherInfo("House Temp", getHouseTemp()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${user.casa.split(":")[1]}:",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: rooms
                    .map((room) => _buildRoomCard(context, room.divName, getDivDevicesOn(room.divName)))
                    .toList(),
              ),
            ),
            const SizedBox(height: 7),
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
            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
  IconData icon = label == "Weather" ? Icons.wb_sunny : Icons.thermostat;

  return GestureDetector(
    onTap: () {
      if (label == "House Temp") {
        _showHouseTempPopup();
      }
    },
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Icon(icon, color: Colors.teal, size: 24),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildRoomCard(BuildContext  context, String roomName, Future<String> devicesOnFuture) {
    bool isRestricted = false;
    for(DivRestriction dr in divRestrictions){
      if(roomName.split(":")[2] == dr.divName && user.username == dr.username){
        isRestricted = true;
      }
    }
    if(isRestricted){
      return Card(
        color: Colors.grey.withOpacity(0.0001),
        elevation: 2,
        child: FutureBuilder<String>(
          future: devicesOnFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String devicesOnText = snapshot.data ?? 'Loading...';
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.withOpacity(0.0001),
                child: const Icon(Icons.lock, color: Colors.teal, size: 30),
              ),
              title: Text(getDivName(roomName)),
              subtitle: Text("Devices on: $devicesOnText"),
              trailing: const Icon(Icons.chevron_right),

            );
          },
        ),
      );
    }else{
      return Card(
        elevation: 2,
        child: FutureBuilder<String>(
          future: devicesOnFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            String devicesOnText = snapshot.data ?? 'Loading...';
            return ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/Logo_init.jpeg'),
                radius: 20,
              ),
              title: Text(getDivName(roomName)),
              subtitle: Text("Devices on: $devicesOnText"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RoomPage(divName: roomName)),
                );
              },
            );
          },
        ),
      );
    }

  }
}