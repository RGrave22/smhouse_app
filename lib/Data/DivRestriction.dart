class DivRestriction {
  final String restrictionName;
  final String username;
  final String divName;

  DivRestriction({
    required this.restrictionName,
    required this.username,
    required this.divName,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'restrictionName': restrictionName,
      'username': username,
      'divName': divName,
    };
  }

  // Create an object from a map
  factory DivRestriction.fromMap(Map<String, dynamic> map) {
    return DivRestriction(
      restrictionName: map['restrictionName'],
      username: map['username'],
      divName: map['divName'],
    );
  }

  @override
  String toString() {
    return 'DivRestriction(restrictionName: $restrictionName, username: $username, divName: $divName)';
  }
}