import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../auth/firebase_auth_services.dart';
import '../auth/validators.dart';

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
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Processing Data')));
      User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (user != null) {
        print('User is signed in successfully');
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Row(
            children: [
              Icon(Icons.dangerous),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text('Invalid credentials'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check the form')));
    }
  }

  Future<void> _signInWithGoogle() async {
    User? user = await _auth.signInWithGoogleService();
    if (user != null) {
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
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Text('Invalid Google credentials'),
              ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 100),
                  ZoomIn(
                    child: Image.asset(
                      "assets/logoAppGastosFixed.png",
                      width: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'HELLO AGAIN',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Welcome back, you've been missed",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  // Email
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                      ),
                      autofocus: false,
                      cursorColor: Colors.black,
                      validator: (String? value) {
                        return Validators.validateEmail(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          borderRadius: BorderRadius.circular(16),
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
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: _isPasswordVisible,
                      validator: (String? value) {
                        if (value!.isEmpty || value == "") {
                          return 'Password is empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Forgot Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/forgot_password");
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Submit
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      ),
                      onPressed: _signIn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Submit",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Sign in with google
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                      ),
                      onPressed: _signInWithGoogle,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(MdiIcons.fromString('google')),
                          const SizedBox(
                            width: 30,
                          ),
                          const Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Register
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not a member? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
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
