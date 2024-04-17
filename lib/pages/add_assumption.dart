import 'dart:ffi';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAssumption extends StatefulWidget {
  const AddAssumption({super.key});

  @override
  State<AddAssumption> createState() => _AddAssumptionState();
}

class _AddAssumptionState extends State<AddAssumption> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'MXN';
  Color bgColorSelected = Colors.green;
  User? user = FirebaseAuth.instance.currentUser;

  //late String assumptionName = '';
  TextEditingController assumptionName = TextEditingController();
  TextEditingController assumptionMont = TextEditingController();
  //late double assumptionAmount = 0;

  // Función para escribir el documento en Firestore
  void escribirDocumento(String name, double amount) {
    // Referencia al documento
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users') // Colección 'users'
        .doc(user!.uid) // Documento 'usuario1'
        .collection('assumption') // Subcolección 'assumption'
        .doc(); // Crear un nuevo documento con ID automático
    print("Funcion ejecutada");
    // Datos a escribir
    Map<String, dynamic> datos = {
      'expense': amount, // Número de gasto
      'name': name, // Nombre del gasto
    };

    print("Funcion ejecutada");

    // Escribir los datos en el documento
    documentReference
        .set(datos)
        .then((value) => print("Documento escrito correctamente"))
        .catchError((error) => print("Error al escribir el documento: $error"));
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            text!.assume_expense,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Text(
                    text!.expense_name,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: TextFormField(
                    controller: assumptionName,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.abc),
                      labelText: text!.concept,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return text!.please_enter_oneletter;
                      }
                      return null; // Retorna null si la validación es exitosa
                    },
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Text(
                    text!.amount_expense,
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Flexible(
                        flex: 1,
                        child: Icon(Icons.monetization_on),
                      ),
                      Flexible(
                        flex: 2,
                        child: TextFormField(
                          controller: assumptionMont,
                          decoration: InputDecoration(
                            labelText: text!.amount,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return text!.enter_value;
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}$'),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              alignment: Alignment.center,
                              value: dropDownValue,
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "MXN",
                                  onTap: () {
                                    setState(() {
                                      dropDownValue = "MXN";
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "MXN",
                                      style: GoogleFonts.poppins(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "USD",
                                  onTap: () {
                                    setState(() {
                                      dropDownValue = "USD";
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "USD",
                                      style: GoogleFonts.poppins(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      escribirDocumento(assumptionName.text,
                          double.parse(assumptionMont.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            text!.correctly_saved_assumption,
                          ),
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text(text!.save_assumption),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
