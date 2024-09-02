/// [OtpType] 0 = email, 1 = sms
class OtpType {
  static const int email = 0;
  static const int sms = 1;
}

/// [OtpLocation] 0 = login, 1 = register, 2 = verify, 3 = forgot pin
class OtpLocation {
  static const int login = 0;
  static const int register = 1;
  static const int verify = 2;
  static const int forgotPin = 3;
}
