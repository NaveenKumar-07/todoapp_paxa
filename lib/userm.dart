class User {
  final String token;
  final int userid;

  User({required this.token,required this.userid});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'], 
      userid: json['id'],
    );
  }
}
