class Validators {


  static String? validateName(String? value) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]").hasMatch(value!);
    if (!emailValid) {
      return 'Type a correct name';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    if (!emailValid) {
      return 'Type a correct email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    RegExp validateUppercase = RegExp(r'[A-Z]');
    RegExp validateDigits = RegExp(r'[0-9]');
    RegExp validateSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (value!.length < 8) {
      return 'Your password must contain at least 8 characters';
    } else if (!value.contains(validateUppercase)) {
      return 'Your password must contain at least one uppercase letter';
    } else if (!value.contains(validateDigits)) {
      return 'Your password must contain at least one digit';
    } else if (!value.contains(validateSpecialCharacters)) {
      return 'Your password must contain at least one special character';
    }
    return null;
  }
}
