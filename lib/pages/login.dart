import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/firebase_auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void listenAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out');
      } else {
        print('User is signed in, his uid is: ${user.uid}');
        Navigator.pushNamed(context, "/home");
      }
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data'))
      );
      User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text
      );
      if (user != null){
        print('User is signed in successfully');
        if (!context.mounted) return;
        Navigator.pushNamed(context, '/home');
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.dangerous),
                SizedBox(width: 20,),
                Expanded(child: Text('Invalid credentials')),
              ],
            ),
            backgroundColor: Colors.red,
          )
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check the form'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    listenAuthChanges();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(milliseconds: 400),
          child: Text("Login",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 67, 229, 239),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                ZoomIn(
                  child: Image.asset(
                    "assets/logoAppGastosFixed.png",
                    width: 200,
                  )
                ),
                // Email
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black), //<-- SEE HERE
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.email),
                        prefixIconColor: Colors.black,
                      ),
                      autofocus: false,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      validator: (String? value){
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                        if (!emailValid){
                          return 'Type a correct email';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // Password
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.black), //<-- SEE HERE
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.password),
                        prefixIconColor: Colors.black,
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      validator: (String? value){
                        if (value!.isEmpty || value == "") {
                          return 'Password is empty';
                        }
                        return null;
                      },
                    ),
                  )
                ),
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: const Text("Submit")
                  )
                ),
                const SizedBox(height: 10),
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text(
                      "Don't have an account? Register here",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}
