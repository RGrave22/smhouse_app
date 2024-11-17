class Light {
  final String lightName;
  final String houseName;
  final String divName;
  late int isOn;
  late String color;
  late int intensity;

  Light({
    required this.lightName,
    required this.houseName,
    required this.divName,
    required this.isOn,
    required this.color,
    required this.intensity,
  });

  Map<String, dynamic> toMap() {
    return {
      'lightName': lightName,
      'houseName': houseName,
      'divName': divName,
      'isOn': isOn,
      'color': color,
      'intensity': intensity,
    };
  }

  factory Light.fromMap(Map<String, dynamic> map) {
    return Light(
      lightName: map['lightName'],
      houseName: map['houseName'],
      divName: map['divName'],
      isOn: map['isOn'],
      color: map['color'],
      intensity: map['intensity'],
    );
  }

  @override
  String toString() {
    return 'Light(lightName: $lightName, houseName: $houseName, divName: $divName, isOn: $isOn, color: $color, intensity: $intensity)';
  }
}