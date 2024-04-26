import 'dart:async';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/home.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool _isEmailVerified = false;
  User? user = FirebaseAuth.instance.currentUser;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isEmailVerified) timer?.cancel();
  }

  void _sendEmailVerification() async {
    await user?.sendEmailVerification();
  }

  void _backToLoginPage() async {
    if (!context.mounted) return;
    Navigator.popAndPushNamed(context, '/login');
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmailVerified) {
      return const Home();
    } else {
      AppLocalizations? text = AppLocalizations.of(context);

      return Scaffold(
        appBar: AppBar(
          title: BounceInDown(
            duration: const Duration(milliseconds: 800),
            child: Text(
              text!.appbarEmailVerification,
              style: GoogleFonts.roboto(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                const Icon(
                  Icons.email,
                  size: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('${text.title_emailVerification} ${user?.email}', textAlign: TextAlign.center,),
                Text(
                  text.subtitle_emailVerification,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: _sendEmailVerification,
                  child: Text(text.resendEmailButton),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _backToLoginPage,
                  child: Text(text.backToLoginPageButton),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
