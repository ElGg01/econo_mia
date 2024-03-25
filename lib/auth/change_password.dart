import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../auth/validators.dart';
import 'firebase_auth_services.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isOldPasswordVisible = true;
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.dangerous),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> showPasswordChangedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password changed'),
          content: SizedBox(
            width: double.maxFinite,
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),),
          ],
          elevation: 16.0,
        );
      },
    );
  }

  Future _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check the form')));
      return;
    }
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.dangerous),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text('There is an old sign-in register. Try to sign in'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      await _auth.reAuthenticateWithEmailAndPassword(
          user!.email, _oldPassword.text);
      await user?.updatePassword(_newPassword.text.trim());
      if (!context.mounted) return;
      showPasswordChangedDialog(context);
    } on FirebaseAuthException catch (e) {
      String wrongPassword = 'Wrong Password';
      String defaultError = 'Something went wrong. Try again later';
      if (e.code == 'wrong-password') {
        showSnackBar(wrongPassword);
      } else {
        showSnackBar(defaultError);
      }
    } catch (e) {
      showSnackBar('Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(
            text!.appbarChangePassword,
            style: GoogleFonts.roboto(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 200,
                  ),
                  Text(
                    text.title_ChangePassword,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    text.subtitle_ChangePassword,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  // Old Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                      controller: _oldPassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: text.oldPasswordTextFormField,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isOldPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isOldPasswordVisible = !_isOldPasswordVisible;
                            });
                          },
                        ),
                      ),
                      autofocus: false,
                      obscureText: _isOldPasswordVisible,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // New password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                        controller: _newPassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: text.newPasswordTextFormField,
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                        autofocus: false,
                        obscureText: _isNewPasswordVisible,
                        validator: (String? value) {
                          return Validators.validatePassword(value, text);
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Confirm New Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: text.confirmPasswordTextFormField,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      autofocus: false,
                      obscureText: _isConfirmPasswordVisible,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String? result = _confirmPassword.text ==
                                _newPassword.text
                            ? null
                            : text.validatorMsg_confirmPassword;
                        return result;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // Submit button
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      ),
                      onPressed: _changePassword,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            text.changePasswordButton,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
