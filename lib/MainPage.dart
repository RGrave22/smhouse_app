import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String username;

  const MainScreen({super.key, required this.username});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Método para exibir o popup customizado
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
                        'Add Room',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Botão de fechar
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.teal),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o popup
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
                            _buildRoomOption(Icons.kitchen, "Kitchen"),
              _buildRoomOption(Icons.bed, "BedRoom"),
              _buildRoomOption(Icons.garage, "Garage"),
              _buildRoomOption(Icons.computer, "Office"),
            ],
          ),
        ),
      );
    },
  );
}



  // Método para criar cada opção de divisão
  Widget _buildRoomOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(label, style: TextStyle(color: Colors.teal)),
      onTap: () {
        // Lógica para seleção da divisão
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label added!')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.teal),
          iconSize: 45,
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.teal),
            iconSize: 45,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/Logo_init.jpeg', height: 80),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherInfo("Weather", "22°"),
                    _buildWeatherInfo("Temp House", "22°"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your House:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildRoomCard('Living Room', '20 Devices On'),
                  _buildRoomCard('Bedroom', '10 Devices On'),
                  _buildRoomCard('Kitchen', '5 Devices On'),
                                    _buildRoomCard('Living Room', '20 Devices On'),
                  _buildRoomCard('Bedroom', '10 Devices On'),
                  _buildRoomCard('Kitchen', '5 Devices On'),
                ],
              ),
            ),
            SizedBox(height: 7),
            Center(
              child: ElevatedButton(
                onPressed: _showAddRoomDialog, // Chama o método para exibir o popup
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildWeatherInfo(String label, String value) {
    IconData icon = label == "Weather" ? Icons.wb_sunny : Icons.thermostat;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            Icon(icon, color: Colors.teal, size: 24),
          ],
        ),
      ],
    );
  }

  Widget _buildRoomCard(String roomName, String devicesOn) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/Logo_init.jpeg'),
        ),
        title: Text(roomName),
        subtitle: Text(devicesOn),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
