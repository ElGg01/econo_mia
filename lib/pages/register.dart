import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async{
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data'))
      );
      User? user = await _auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text
      );
      if (user != null){
        print('User is signed in successfully');
        if (!context.mounted) return;
        // Navigator.pushNamed(context, '/home');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        print('Some error happened');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check the form'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text("REGISTRATION",
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24
            )
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
                // Name
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Colors.black
                          ),
                        ),
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: Colors.black,
                      ),
                      autofocus: false,
                      style: const TextStyle(color: Colors.black),
                      cursorColor: Colors.black,
                      validator: (String? value){
                        bool emailValid = RegExp(r"^[a-zA-Z0-9a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]").hasMatch(value!);
                        if (!emailValid){
                          return 'Type a correct name';
                        }
                        return null;
                      },
                    ),
                  ),
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
                          borderSide: BorderSide(
                            width: 2, color: Colors.black
                          ),
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
                          borderSide: BorderSide(
                            width: 2, color: Colors.black
                          ),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.password),
                        prefixIconColor: Colors.black,
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                      validator: (String? value){
                        RegExp validateUppercase = RegExp(r'[A-Z]');
                        RegExp validateDigits = RegExp(r'[0-9]');
                        RegExp validateSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
                        if (value!.length < 8) {
                          return 'Your password must contain at least 8 characters';
                        }
                        else if (!value.contains(validateUppercase)){
                          return 'Your password must contain at least one uppercase letter';
                        }
                        else if (!value.contains(validateDigits)){
                          return 'Your password must contain at least one digit';
                        }
                        else if (!value.contains(validateSpecialCharacters)){
                          return 'Your password must contain at least one special character';
                        }
                        return null;
                      },
                    ),
                  )
                ),
                // Enter button
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: const Text("Submit")
                  )
                ),
                const SizedBox(height: 10),
                FadeInUpBig(
                  delay: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                    )
                  )
                ),
                const SizedBox( height: 20, )
              ]
            ),
          ),
        ),
      )
    );
  }
}
