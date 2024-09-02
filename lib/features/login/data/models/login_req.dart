class LoginReq {
  final String username;
  final String password;
  final String firebaseToken;

  LoginReq({
    required this.username,
    required this.password,
    required this.firebaseToken,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['username'] = username;
    data['password'] = password;
    data['firebase_token'] = firebaseToken;
    return data;
  }
}
