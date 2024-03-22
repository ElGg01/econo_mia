import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../auth/validators.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    super.dispose();
  }

  void _changePassword(){
    if (_formKey.currentState!.validate()){

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
          child: Text("Change Password",
              style: GoogleFonts.roboto(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 24
              )
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30,),
                  // Old Password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                      controller: _oldPassword,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).colorScheme.onBackground
                          ),
                        ),
                        labelText: "Old Password",
                        prefixIcon: const Icon(Icons.password),
                      ),
                      autofocus: false,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // New password
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: TextFormField(
                        controller: _oldPassword,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Theme.of(context).colorScheme.onBackground
                            ),
                          ),
                          labelText: "New Password",
                          prefixIcon: const Icon(Icons.password),
                        ),
                        autofocus: false,
                        validator: (String? value){
                          return Validators.validatePassword(value);
                        }
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // Submit button
                  FadeInUpBig(
                    delay: const Duration(milliseconds: 100),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _changePassword,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Submit",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.background
                              ),
                            ),
                          ],
                        )
                    ),
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

