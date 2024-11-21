class DevRestriction {
  final String restrictionName;
  final String deviceName;
  final String username;
  final String deviceRoomName;
  final int startingTimeHour;
  final int startingTimeMinute;
  final int endTimeHour;
  final int endTimeMinute;
  final bool isAllDay;

  DevRestriction({
    required this.restrictionName,
    required this.deviceName,
    required this.username,
    required this.deviceRoomName,
    required this.startingTimeHour,
    required this.startingTimeMinute,
    required this.endTimeHour,
    required this.endTimeMinute,
    required this.isAllDay,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'restrictionName': restrictionName,
      'deviceName': deviceName,
      'username': username,
      'deviceRoomName': deviceRoomName,
      'startingTimeHour': startingTimeHour,
      'startingTimeMinute': startingTimeMinute,
      'endTimeHour': endTimeHour,
      'endTimeMinute': endTimeMinute,
      'isAllDay': isAllDay ? 1 : 0, // Store as integer (1 for true, 0 for false)
    };
  }

  // Create an object from a map
  factory DevRestriction.fromMap(Map<String, dynamic> map) {
    return DevRestriction(
      restrictionName: map['restrictionName'],
      deviceName: map['deviceName'],
      username: map['username'],
      deviceRoomName: map['deviceRoomName'],
      startingTimeHour: map['startingTimeHour'],
      startingTimeMinute: map['startingTimeMinute'],
      endTimeHour: map['endTimeHour'],
      endTimeMinute: map['endTimeMinute'],
      isAllDay: map['isAllDay'] == 1, // Convert integer to boolean
    );
  }

  @override
  String toString() {
    return 'DevRestriction(restrictionName: $restrictionName, deviceName: $deviceName, username: $username, deviceRoomName: $deviceRoomName, startingTimeHour: $startingTimeHour, startingTimeMinute: $startingTimeMinute, endTimeHour: $endTimeHour, endTimeMinute: $endTimeMinute, isAllDay: $isAllDay)';
  }
}