import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class AddBalanceAccount extends StatefulWidget {
  const AddBalanceAccount({super.key});

  @override
  State<AddBalanceAccount> createState() => _AddBalanceAccountState();
}

class _AddBalanceAccountState extends State<AddBalanceAccount> {
  TextEditingController _balanceAccountName = TextEditingController();
  String dropDownValue = 'MXN';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            "Añade una cuenta",
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
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      left: 40,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Saldo inicial',
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
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_balance),
                      labelText: "Nombre de la cuenta",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa al menos una letra.';
                      }
                      return null; // Retorna null si la validación es exitosa
                    },
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
