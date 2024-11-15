class Casa {
  final String houseName;
  final String houseTemp;
  final int houseOn;

  Casa({
    required this.houseName,
    required this.houseTemp,
    required this.houseOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'houseName': houseName,
      'houseTemp': houseTemp,
      'houseOn': houseOn,
    };
  }

  factory Casa.fromMap(Map<String, dynamic> map) {
    return Casa(
      houseName: map['houseName'],
      houseTemp: map['houseTemp'],
      houseOn: map['houseOn'],
    );
  }

  @override
  String toString() {
    return 'Casa(houseName: $houseName, houseTemp: $houseTemp, houseOn: $houseOn)';
  }
}