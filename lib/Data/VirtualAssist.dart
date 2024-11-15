class VirtualAssist {
  final String vaName;
  final String houseName;
  final String divName;
  final int isOn;
  final int volume;
  final int isPlaying;
  final String music;
  final int isMuted;
  final int alarm;

  VirtualAssist({
    required this.vaName,
    required this.houseName,
    required this.divName,
    required this.isOn,
    required this.volume,
    required this.isPlaying,
    required this.music,
    required this.isMuted,
    required this.alarm,
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
      'alarm': alarm,
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
      alarm: map['alarm'],
    );
  }

  @override
  String toString() {
    return 'VirtualAssist(vaName: $vaName, houseName: $houseName, divName: $divName, isOn: $isOn, volume: $volume, isPlaying: $isPlaying, music: $music, isMuted: $isMuted, alarm: $alarm)';
  }
}