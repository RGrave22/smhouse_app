class User {
  final String username;
  final String password;
  final String email;

  User({
    required this.username,
    required this.password,
    required this.email,
  });

  // Convert a User object to a map (for inserting into the database)
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }

  // Create a User object from a map (for retrieving from the database)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }

  // Optionally, you can override `toString` to make it more readable when printing
  @override
  String toString() {
    return 'User(username: $username, password: $password, email: $email)';
  }
}