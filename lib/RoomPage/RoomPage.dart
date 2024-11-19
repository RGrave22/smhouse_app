import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smhouse_app/AC/ACPage.dart';
import 'package:smhouse_app/Data/Division.dart';
import 'package:smhouse_app/VirtualAssist/VirtualAssistPage.dart';
import 'package:smhouse_app/main.dart';

import '../DB/DB.dart';
import '../Data/Device.dart';
import '../HomePage.dart';
import '../Light/LightPage.dart';
import '../Profile/ProfilePage.dart';

class RoomPage extends StatefulWidget {
  final String divName;

  const RoomPage({super.key, required this.divName});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _roomNameController = TextEditingController();
  final LocalDB db = LocalDB('SmHouse');

  bool isLoading = true;

  late Division div;
  List<Device> devices = [];

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> getInfo() async {
    setState(() {
      isLoading = true;
    });
    div = await db.getDivision(widget.divName);

    devices = await db.getDevicesOfDivision(widget.divName);

    setState(() {
      isLoading = false;
    });
  }

  bool isDeviceOn(String devName) {
    Device? device = devices.firstWhere((device) => device.devName == devName);

    return device.isOn == 1;
  }

  void _onDeviceSwitchChanged(String devName, bool value) {
    setState(() {
      Device device = devices.firstWhere((dev) => dev.devName == devName);

      Device updatedDevice = Device(
        devName: device.devName,
        isOn: value ? 1 : 0,
        type: device.type,
        divName: device.divName,
        houseName: device.houseName,
      );

      int index = devices.indexOf(device);
      if (index != -1) {
        devices[index] = updatedDevice;
        db.updateDeviceStatus(updatedDevice, value ? 1 : 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.teal),
            iconSize: 50,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              icon: const Icon(Icons.account_circle, color: Colors.teal),
              iconSize: 50,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/Logo_init.jpeg'),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                div.divName.split(":")[2],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: _showEditDialog,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: devices
                            .map((dev) => _buildDeviceCard(
                                context,
                                dev,
                                isDeviceOn(dev.devName),
                                (value) =>
                                    _onDeviceSwitchChanged(dev.devName, value)))
                            .toList(),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ));
  }

  void _showEditDialog() {
    _roomNameController.text = div.divName.split(":")[2];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Room Name'),
          content: TextField(
            controller: _roomNameController,
            decoration: const InputDecoration(
              labelText: 'Room Name',
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
                  List<String> name = div.divName.split(":");
                  String newName =
                      "${name[0]}:${name[1]}:${_roomNameController.text}";
                  db.updateDivName(newName, div.divName);

                  div = Division(
                    divName: newName,
                    houseName: div.houseName,
                    divON: div.divON,
                    divTemp: div.divTemp,
                  );
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

  Widget _buildDeviceCard(BuildContext context, Device dev, bool isDeviceOn,
      ValueChanged<bool> onChanged) {
    IconData deviceIcon;
    switch (dev.type) {
      case 'light':
        deviceIcon = Icons.lightbulb;
        break;
      case 'ac':
        deviceIcon = Icons.air;
        break;
      case 'virtualAssist':
        deviceIcon = Icons.surround_sound;
        break;
      default:
        deviceIcon = Icons.devices;
        break;
    }

    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Icon(deviceIcon, color: Colors.white),
        ),
        title: Text(dev.devName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: isDeviceOn,
              onChanged: onChanged,
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          switch (dev.type) {
            case 'light':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LightPage(lightName: dev.devName)),
              );
              break;
            case 'ac':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AcPage(acName: dev.devName)),
              );
              break;
            case 'virtualAssist':
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VirtualAssistPage(vaName: dev.devName)),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
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
                // Header com texto centralizado e botão de fechar
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Texto "Add Room"
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add Device',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // Botão de fechar
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.teal),
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o popup
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Lista de divisões
                _buildDeviceOption(Icons.air, "Air Conditioner"),
                _buildDeviceOption(Icons.surround_sound, "Virtual Assistant"),
                _buildDeviceOption(Icons.lightbulb, "Light"),
                //_buildRoomOption(Icons.computer, "Office"),
                //_buildRoomOption(Icons.tv_rounded, "Living Room"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeviceOption(IconData icon, String label) {
    String deviceTipe = "";
    switch (label) {
      case 'Air Conditioner':
        deviceTipe = "ac";
        break;
      case 'Virtual Assistant':
        deviceTipe = "virtualAssist";
        break;
      case 'Light':
        deviceTipe = "light";
        break;
      default:
    }

    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: const TextStyle(color: Colors.teal)),
      onTap: () {
        Navigator.of(context).pop();
        _showEditDeviceDialog(deviceTipe);
      },
    );
  }

  void _showEditDeviceDialog(String deviceType) {
    TextEditingController _devNameController = TextEditingController();

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
                          'Edit Device',
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
                TextField(
                  controller: _devNameController,
                  decoration: const InputDecoration(
                    labelText: 'Device Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Device device = Device(
                        devName: _devNameController.text,
                        isOn: 0,
                        type: deviceType,
                        divName: div.divName,
                        houseName: div.houseName);
                    Navigator.of(context).pop();
                    setState(() {
                      devices.add(device);
                    });
                    db.createDevice(device);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Device created!')),
                    );
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
}
