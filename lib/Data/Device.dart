class Device {
  final String devName;
  final int isOn;
  final String type;
  final String divName;
  final String houseName;

  Device({
    required this.devName,
    required this.isOn,
    required this.type,
    required this.divName,
    required this.houseName,
  });


  Map<String, dynamic> toMap() {
    return {
      'devName': devName,
      'isOn': isOn,
      'type': type,
      'divName': divName,
      'houseName': houseName,
    };
  }


  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      devName: map['devName'],
      isOn: map['isOn'],
      type: map['type'],
      divName: map['divName'],
      houseName: map['houseName'],
    );
  }

  @override
  String toString() {
    return 'Device(devName: $devName, isOn: $isOn, type: $type, divName: $divName, houseName: $houseName)';
  }
}