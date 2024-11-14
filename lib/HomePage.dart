import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista para armazenar as divisões criadas, com algumas salas padrão
  List<String> rooms = ['Living Room', 'Bedroom', 'Kitchen'];

  // Método para exibir o popup de seleção de tipo de sala
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
                      icon: const Icon(Icons.close, color: Colors.teal),
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
                onPressed: () {
                  // Verifica se o campo está vazio e atribui um nome padrão
                  String roomName = _roomNameController.text.isEmpty
                      ? 'Room ${rooms.length + 1}'
                      : _roomNameController.text;
                  
                  Navigator.of(context).pop();
                  setState(() {
                    rooms.add(roomName);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Room "$roomName" created!')),
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
     
      body: Padding(
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
                    _buildWeatherInfo("Temp House", "22°"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your House:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: rooms
                    .map((room) => _buildRoomCard(room, 'Devices On')) 
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

    return Column(
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
    );
  }

  Widget _buildRoomCard(String roomName, String devicesOn) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/Logo_init.jpeg'),
        ),
        title: Text(roomName),
        subtitle: Text(devicesOn),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}