class ValidationUtils {
  static bool mobilePhone(String value) {
    // RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{9,14}$)');
    // RegExp regex = RegExp(r'(^(?:[0]9)?[0-9]{9,14}$)');
    RegExp regex = RegExp(r'(^(?:[0]9)?[0-9]{9,13})+$');
    if (value.isEmpty) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }

  static bool email(String value) {
    RegExp regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }

  static bool password(String value) {
    // RegExp regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,12}$');
    if (value.isEmpty) {
      return false;
    } else {
      bool isValid = value.length >= 6;
      return isValid;
    }
  }

  static bool pin(String value) {
    RegExp regex = RegExp(r'^[0-9]+$');
    if (value.length < 6) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }

  static bool ktpNumber(String value) {
    RegExp regex = RegExp(r'^[0-9]+$');
    if (value.length != 16) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }

  static bool npwpNumber(String value, {bool ignoreLength = false}) {
    RegExp regex = RegExp(r'^[0-9]+$');
    if (ignoreLength) {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
    if (value.length != 15) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }

  static bool rekeningNumber(String value) {
    RegExp regex = RegExp(r'^[0-9]+$');
    if (value.length < 10) {
      return false;
    } else {
      bool isValid = regex.hasMatch(value);
      return isValid;
    }
  }
}
