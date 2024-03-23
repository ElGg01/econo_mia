import 'dart:async';

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

    if (!_isEmailVerified){
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified()
      );
    }
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (_isEmailVerified) timer?.cancel();
  }

  void _sendEmailVerification() async{
    await user?.sendEmailVerification();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _isEmailVerified
    ? const Home()
    : Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(
            "Email Verification",
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
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30,),
              const Icon(Icons.email, size: 200, ),
              const SizedBox(height: 30,),
              Text('An email was sent to ${user?.email}'),
              const Text('Please verify your email address to continue'),
              const SizedBox(height: 50,),
              ElevatedButton(
                onPressed: _sendEmailVerification,
                child: const Text('Re-send email-verification'),
              )
            ],
          ),
        ),
      ),
    );
 }