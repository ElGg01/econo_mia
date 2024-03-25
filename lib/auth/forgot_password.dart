import 'package:animate_do/animate_do.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:econo_mia/auth/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _passwordReset() async {
    if (!_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check the form'))
      );
      return;
    }
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (!context.mounted) return;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return AlertDialog(
              title: const Text('Email sent'),
              content: const Text('An email was sent to your account to reset password'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Ok')
                )
              ],
              elevation: 24.0,
            );
          }
      );
    } on FirebaseAuthException catch (e){
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.dangerous),
              SizedBox(width: 20,),
              Expanded(child: Text('There is no associated account for this email'),),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    final AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(text!.appbar_password_forgotten,
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                ZoomIn(
                  child: Image.asset(
                    "assets/logoAppGastosFixed.png",
                    width: 200,
                  ),
                ),
                const SizedBox(height: 200,),
                Text(text.title_password_forgotten,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30,),
                Column(
                  children: <Widget>[
                    FadeInUpBig(
                      delay: const Duration(milliseconds: 300),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.onBackground
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: text.emailTextFormField,
                          prefixIcon: const Icon(Icons.email),
                        ),
                        autofocus: false,
                        cursorColor: Colors.black,
                        validator: (String? value){
                          return Validators.validateEmail(value, text);
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                    FadeInUpBig(
                      delay: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        ),
                        onPressed: _passwordReset,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              text.resetPasswordButton,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
