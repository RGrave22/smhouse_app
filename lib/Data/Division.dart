class Division {
  final String divName;
  final String houseName;
  final int divON;
  final String divTemp;

  Division({
    required this.divName,
    required this.houseName,
    required this.divON,
    required this.divTemp,
  });

  Map<String, dynamic> toMap() {
    return {
      'divName': divName,
      'houseName': houseName,
      'divON': divON,
      'divTemp': divTemp,
    };
  }

  factory Division.fromMap(Map<String, dynamic> map) {
    return Division(
      divName: map['divName'],
      houseName: map['houseName'],
      divON: map['divON'],
      divTemp: map['divTemp'],
    );
  }

  @override
  String toString() {
    return 'Division(divName: $divName, houseName: $houseName, divON: $divON, divTemp: $divTemp)';
  }
}