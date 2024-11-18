class AC {
  final String acName;
  final String houseName;
  final String divName;
  late final int isOn;
  late String acMode;
  late int acHoursTimer;
  late int acMinutesTimer;
  late int swingModeOn;
  late int airDirection;
  late int acTemp;

  AC({
    required this.acName,
    required this.houseName,
    required this.divName,
    required this.isOn,
    required this.acMode,
    required this.acHoursTimer,
    required this.acMinutesTimer,
    required this.swingModeOn,
    required this.airDirection,
    required this.acTemp,
  });

  Map<String, dynamic> toMap() {
    return {
      'acName': acName,
      'houseName': houseName,
      'divName': divName,
      'isOn': isOn,
      'acMode': acMode,
      'acHoursTimer': acHoursTimer,
      'acMinutesTimer': acMinutesTimer,
      'swingModeOn': swingModeOn,
      'airDirection': airDirection,
      'acTemp': acTemp,
    };
  }

  factory AC.fromMap(Map<String, dynamic> map) {
    return AC(
      acName: map['acName'],
      houseName: map['houseName'],
      divName: map['divName'],
      isOn: map['isOn'],
      acMode: map['acMode'],
      acHoursTimer: map['acHoursTimer'],
      acMinutesTimer: map['acMinutesTimer'],
      swingModeOn: map['swingModeOn'],
      airDirection: map['airDirection'],
      acTemp: map['acTemp'],
    );
  }

  @override
  String toString() {
    return 'AC(acName: $acName, houseName: $houseName, divName: $divName, isOn: $isOn, acMode: $acMode, acHoursTimer: $acHoursTimer, acMinutesTimer: $acMinutesTimer, swingModeOn: $swingModeOn, airDirection: $airDirection, acTemp: $acTemp)';
  }
}