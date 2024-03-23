import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  bool _isPasswordVisible = true;


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
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.dangerous),
                SizedBox(width: 20,),
                Expanded(child: Text('Invalid credentials'),),
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

  Future<void> _signInWithGoogle() async {
    User? user = await _auth.signInWithGoogleService();
    if (user != null){
      print('User is signed in successfully');
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: <Widget>[
              Icon(Icons.dangerous),
              SizedBox(width: 20,),
              Expanded(child: Text('Invalid Google credentials'),),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
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
          duration: const Duration(milliseconds: 800),
          child: Text("Login",
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
        child: SingleChildScrollView(
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
                    ),
                  ),
                  const SizedBox( height: 50, ),
                  // Email
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
                        ),
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      autofocus: false,
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
                  const SizedBox( height: 20, ),
                  // Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: (){
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _isPasswordVisible,
                      validator: (String? value){
                        if (value!.isEmpty || value == "") {
                          return 'Password is empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox( height: 20, ),
                  // Submit
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: _signIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Sign in with google
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      onPressed: _signInWithGoogle,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(MdiIcons.fromString('google')),
                          const SizedBox(width: 30,),
                          const Text('Sign in with Google'),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Register
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
                            decoration: TextDecoration.underline
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
