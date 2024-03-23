import 'package:econo_mia/pages/home.dart';
import 'package:econo_mia/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data != null){
            return const Home();
          } else {
            return const Login();
          }
        }
      },
    );
  }
}
