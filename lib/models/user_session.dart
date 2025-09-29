class UserSession {
  String username;
  String password;

  UserSession({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}
