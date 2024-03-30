import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

class AddEarning extends StatefulWidget {
  const AddEarning({super.key});

  @override
  State<AddEarning> createState() => _AddEarningState();
}

class _AddEarningState extends State<AddEarning> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'MXN';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            "Añade un ingreso",
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
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_balance),
                      labelText: "Concepto del ingreso",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa al menos una letra.';
                      }
                      return null; // Retorna null si la validación es exitosa
                    },
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      left: 60,
                      top: 10,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Monto',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Introduce un valor";
                              }
                              return null;
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
                          fit: FlexFit.tight,
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
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
                                          fontSize: 18,
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
                                          fontSize: 18,
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
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cuenta guardada correctamente"),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.save),
                    label: Text("Guardar cuenta"),
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
