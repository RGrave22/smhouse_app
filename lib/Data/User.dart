class User {
  final String username;
  final String password;
  final String email;

  User({
    required this.username,
    required this.password,
    required this.email,
  });


  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
    };
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }


  @override
  String toString() {
    return 'User(username: $username, password: $password, email: $email)';
  }
}