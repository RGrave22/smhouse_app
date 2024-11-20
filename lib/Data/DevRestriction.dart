class DevRestriction {
  final String restrictionName;
  final String deviceName;
  final String username;
  final String startingTime;
  final String endTime;

  DevRestriction({
    required this.restrictionName,
    required this.deviceName,
    required this.username,
    required this.startingTime,
    required this.endTime,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'restrictionName': restrictionName,
      'deviceName': deviceName,
      'username': username,
      'startingTime': startingTime,
      'endTime': endTime,
    };
  }

  // Create an object from a map
  factory DevRestriction.fromMap(Map<String, dynamic> map) {
    return DevRestriction(
      restrictionName: map['restrictionName'],
      deviceName: map['deviceName'],
      username: map['username'],
      startingTime: map['startingTime'],
      endTime: map['endTime'],
    );
  }

  @override
  String toString() {
    return 'DevRestriction(restrictionName: $restrictionName, deviceName: $deviceName, username: $username, startingTime: $startingTime, endTime: $endTime)';
  }
}
