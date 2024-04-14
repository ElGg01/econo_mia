import 'package:econo_mia/widgets/custom_icon_text_form_field.dart';
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

  late String assumptionName = '';
  late double assumptionAmount = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            "Asume un gasto",
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
                    "Nombre del gasto:",
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
                    decoration: const InputDecoration(
                      icon: Icon(Icons.abc),
                      labelText: "Concepto",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      assumptionName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa al menos una letra.';
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
                    "Monto del gasto:",
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
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Introduce un valor";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            assumptionAmount = double.parse(value);
                          },
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
                      escribirDocumento(assumptionName, assumptionAmount);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Suposición de gasto guardado correctamente",
                          ),
                        ),
                      );
                      Navigator.pop(context, true);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Guardar suposición"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
