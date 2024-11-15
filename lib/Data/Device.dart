class Device {
  final String devName;
  final int isOn;
  final String type;

  Device({
    required this.devName,
    required this.isOn,
    required this.type,
  });

  // Convert a Device object to a Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'devName': devName,
      'isOn': isOn,
      'type': type,
    };
  }

  // Create a Device object from a Map retrieved from the database
  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      devName: map['devName'],
      isOn: map['isOn'],
      type: map['type'],
    );
  }

  @override
  String toString() {
    return 'Device(devName: $devName, isOn: $isOn, type: $type)';
  }
}