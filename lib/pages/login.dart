import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BounceInDown(
            duration: const Duration(seconds: 1),
            child: Text("INICIAR SESIÓN",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        backgroundColor: Colors.cyan,
        body: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(height: 30),
              ZoomIn(
                  child: Image.asset(
                "assets/logoAppGastosFixed.png",
                width: 200,
              )),
              FadeInUpBig(
                delay: const Duration(milliseconds: 500),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 2, color: Colors.white), //<-- SEE HERE
                      ),
                      labelText: "Correo",
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.email),
                      prefixIconColor: Colors.white,
                    ),
                    autofocus: false,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
              ),
              FadeInUpBig(
                  delay: const Duration(milliseconds: 1000),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.white), //<-- SEE HERE
                        ),
                        labelText: "Contraseña",
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.password),
                        prefixIconColor: Colors.white,
                      ),
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              FadeInUpBig(
                  delay: const Duration(milliseconds: 1500),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      child: const Text("Entrar"))),
              const SizedBox(height: 10),
              FadeInUpBig(
                  delay: const Duration(milliseconds: 2000),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: const Text(
                        "¿No tienes cuenta?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      )))
            ]),
          ),
        ));
  }
}
