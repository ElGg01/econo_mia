import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static String? validateName(String? value, AppLocalizations? text) {
    bool emailValid =
        RegExp(r"^[a-zA-Z0-9a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]").hasMatch(value!);
    if (!emailValid) {
      return text!.validatorMsg_nameTextFormField;
    }
    return null;
  }

  static String? validateEmail(String? value, AppLocalizations? text) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    if (!emailValid) {
      return text!.validatorMsg_emailTextFormField;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLocalizations? text) {
    RegExp validateUppercase = RegExp(r'[A-Z]');
    RegExp validateDigits = RegExp(r'[0-9]');
    RegExp validateSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (value!.length < 8) {
      return text!.validatorMsg_passwordCaseLengthTextFormField;
    } else if (!value.contains(validateUppercase)) {
      return text!.validatorMsg_passwordCaseUpperCaseTextFormField;
    } else if (!value.contains(validateDigits)) {
      return text!.validatorMsg_passwordCaseDigitTextFormField;
    } else if (!value.contains(validateSpecialCharacters)) {
      return text!.validatorMsg_passwordCaseSpecialCharTextFormField;
    }
    return null;
  }

  static String? validatePasswordOnLogin(String? value, AppLocalizations? text) {
    if (value!.isEmpty || value == "") {
      return text!.validatorMsg_passwordCaseEmptyTextFormField;
    }
    return null;
  }
}
