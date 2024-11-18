class VirtualAssist {
  final String vaName;
  final String houseName;
  final String divName;
  final int isOn;
  late int volume;
  late int isPlaying;
  late String music;
  late int isMuted;
  late int alarmHours;
  late int alarmMinutes;

  VirtualAssist({
    required this.vaName,
    required this.houseName,
    required this.divName,
    required this.isOn,
    required this.volume,
    required this.isPlaying,
    required this.music,
    required this.isMuted,
    required this.alarmHours,
    required this.alarmMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'vaName': vaName,
      'houseName': houseName,
      'divName': divName,
      'isOn': isOn,
      'volume': volume,
      'isPlaying': isPlaying,
      'music': music,
      'isMuted': isMuted,
      'alarmHours': alarmHours,
      'alarmMinutes': alarmMinutes,
    };
  }

  factory VirtualAssist.fromMap(Map<String, dynamic> map) {
    return VirtualAssist(
      vaName: map['vaName'],
      houseName: map['houseName'],
      divName: map['divName'],
      isOn: map['isOn'],
      volume: map['volume'],
      isPlaying: map['isPlaying'],
      music: map['music'],
      isMuted: map['isMuted'],
      alarmHours: map['alarmHours'],
      alarmMinutes: map['alarmMinutes'],
    );
  }

  @override
  String toString() {
    return 'VirtualAssist(vaName: $vaName, houseName: $houseName, divName: $divName, isOn: $isOn, volume: $volume, isPlaying: $isPlaying, music: $music, isMuted: $isMuted, alarmHours: $alarmHours, alarmMinutes: $alarmMinutes)';
  }
}