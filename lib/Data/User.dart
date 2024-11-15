class User {
  final String username;
  final String password;
  final String email;
  final String casa;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.casa,
  });


  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'casa': casa
    };
  }


  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'],
      password: map['password'],
      email: map['email'],
      casa: map['casa']
    );
  }


  @override
  String toString() {
    return 'User(username: $username, password: $password, email: $email, casa: $casa)';
  }
}