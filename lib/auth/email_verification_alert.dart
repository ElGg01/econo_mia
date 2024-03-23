import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EmailVerificationAlert extends StatelessWidget {
  const EmailVerificationAlert({super.key, required this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Verify your email'),
      content: Text(
        'An email has been sent to ${user?.email}. '
        'Please verify your email address'
        'Unverified email addresses will be deleted on 30 days'
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
