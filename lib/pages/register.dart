import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:econo_mia/auth/validators.dart';
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
  bool _isPasswordVisible = true;

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
        await user.updateDisplayName(_nameController.text);
        await user.sendEmailVerification();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/email_verification',
          (route) => false
        );
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
          duration: const Duration(milliseconds: 800),
          child: Text("REGISTRATION",
            style: GoogleFonts.roboto(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 24
            )
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
                  const SizedBox(height: 60),
                  ZoomIn(
                    child: Image.asset(
                      "assets/logoAppGastosFixed.png",
                      width: 200,
                    )
                  ),
                  const SizedBox( height: 100, ),
                  const Text('BECOME A MEMBER!',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox( height: 20, ),
                  const Text("Fill the form to sign up in our app",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox( height: 50, ),
                  // Name
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: "Name",
                        prefixIcon: const Icon(Icons.person),
                      ),
                      autofocus: false,
                      validator: (String? value){
                        return Validators.validateName(value);
                      },
                    ),
                  ),
                  const SizedBox( height: 20, ),
                  // Email
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
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
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      autofocus: false,
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
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordVisible,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.onBackground
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                          ),
                          onPressed: (){
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
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
                    )
                  ),
                  const SizedBox( height: 20, ),
                  // Enter button
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      ),
                      onPressed: _signUp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Submit",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontSize: 18,
                          ),
                          ),
                        ],
                      )
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Log in
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Sign in here",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                              fontSize: 18,
                            ),
                          )
                        ),
                      ],
                    )
                  ),
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}
