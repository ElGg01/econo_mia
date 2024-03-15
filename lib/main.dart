import 'package:econo_mia/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:econo_mia/pages/login.dart';
import 'package:econo_mia/pages/home.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
      },
      initialRoute: "/login",
    );
  }
}
