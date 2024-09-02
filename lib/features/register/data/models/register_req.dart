class RegisterReq {
  String? name;
  String? phoneNumber;
  String? email;
  String? password;

  RegisterReq({this.name, this.phoneNumber, this.email, this.password});

  RegisterReq.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
