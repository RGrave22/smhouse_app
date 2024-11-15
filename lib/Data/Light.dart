class Light {
  final String lightName;
  final String houseName;
  final String divName;
  final int isOn;
  final String color;

  Light({
    required this.lightName,
    required this.houseName,
    required this.divName,
    required this.isOn,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'lightName': lightName,
      'houseName': houseName,
      'divName': divName,
      'isOn': isOn,
      'color': color,
    };
  }

  factory Light.fromMap(Map<String, dynamic> map) {
    return Light(
      lightName: map['lightName'],
      houseName: map['houseName'],
      divName: map['divName'],
      isOn: map['isOn'],
      color: map['color'],
    );
  }

  @override
  String toString() {
    return 'Light(lightName: $lightName, houseName: $houseName, divName: $divName, isOn: $isOn, color: $color)';
  }
}