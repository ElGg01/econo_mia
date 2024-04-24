import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:econo_mia/auth/validators.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  final db = FirebaseFirestore.instance;

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

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Processing Data')));
      User? user = await _auth
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((credential) {
        //Inicialización de subcolección
        //Es una inicialización de campos vacios solo para que se genere el usuario sin campos
        final datos = <String, dynamic>{
          "expense": 0,
          "name": "assumption",
        };
        //Subcoleccion de ingresos
        //!!!!!!!!!!!!!!CAMBIAR EL USUARIO AL ACTIVO
        final refIngresos = db
            .collection('users')
            .doc(credential!.uid)
            .collection('assumption')
            .doc();
        refIngresos.set(datos);
        final refEgresos = db
            .collection('users')
            .doc(credential!.uid)
            .collection('transactions')
            .doc();

        // Datos a escribir
        Map<String, dynamic> new_datos = {
          'concepto': "apertura", // ID del documento
          'fecha': Timestamp.fromDate(DateTime.now()), // Número de gasto
          'monto': 100, // Nombre del gasto
          'categoria': 1
        };
        refEgresos.set(new_datos);

        //Generación de campo SALDO, este cambiara con cada ingreso y egreso
        final refUsuario = db.collection('users').doc(credential!.uid);
        refUsuario.set({"saldo": 0.0});

        return credential;
      });
      if (user != null) {
        await user.updateDisplayName(_nameController.text);
        await user.sendEmailVerification();
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
            context, '/email_verification', (route) => false);
      } else {
        print('Some error happened');
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Check the form')));
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
        appBar: AppBar(
          title: BounceInDown(
            duration: const Duration(milliseconds: 800),
            child: Text(text!.appbar_register_page,
                style: GoogleFonts.roboto(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 24)),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
                      const SizedBox(height: 20),
                      ZoomIn(
                          child: Image.asset(
                        "assets/logoAppGastosFixed.png",
                        width: 150,
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        text.titleRegisterPage,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        text.subtitleRegisterPage,
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Name
                      FadeInUpBig(
                        delay: const Duration(milliseconds: 100),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            labelText: text.nameTextFormField,
                            prefixIcon: const Icon(Icons.person),
                          ),
                          autofocus: false,
                          validator: (String? value) {
                            return Validators.validateName(value, text);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Email
                      FadeInUpBig(
                        delay: const Duration(milliseconds: 100),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            labelText: text.emailTextFormField,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          autofocus: false,
                          validator: (String? value) {
                            return Validators.validateEmail(value, text);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              labelText: text.passwordTextFormField,
                              prefixIcon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                            validator: (String? value) {
                              return Validators.validatePassword(value, text);
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      // Enter button
                      FadeInUpBig(
                        delay: const Duration(milliseconds: 100),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            ),
                            onPressed: _signUp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  text.submitButton,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(height: 20),
                      // Log in
                      FadeInUpBig(
                          delay: const Duration(milliseconds: 100),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                text.helperMessageToLogIn,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    text.signInHereLink,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      fontSize: 18,
                                    ),
                                  )),
                            ],
                          )),
                    ]),
              ),
            ),
          ),
        ));
  }
}
