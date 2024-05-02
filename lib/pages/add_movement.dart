import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econo_mia/widgets/custom_icon_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddMovement extends StatefulWidget {
  const AddMovement({super.key});

  @override
  State<AddMovement> createState() => _AddMovementState();
}

class _AddMovementState extends State<AddMovement> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController concept = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController date = TextEditingController();

  DateTime now = DateTime.now();
  late DateTime datePicked = DateTime(now.year, now.month, now.day);
  late int? valueItemDropDown;
  // final List<String> listItemDropDown = ["Egreso", "Ingreso"];

  @override
  void initState() {
    super.initState();
    valueItemDropDown = 1;
  }

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void addMovement(
      String concept, double amount, int category, DateTime date) async {
    // Referencia al documento
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users') // Colección 'users'
        .doc(user!.uid) // Documento 'usuario1'
        .collection('transactions') // Subcolección 'transactions'
        .doc(); // Crear un nuevo documento con ID automático
    // Obtener el ID del documento generado automáticamente
    String documentId = documentReference.id;

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    double currentBalance = double.parse(userData['saldo'].toString());

    // Datos a escribir
    Map<String, dynamic> datos = {
      'id': documentId, // ID del documento
      'monto': amount.toInt(), // Número de gasto
      'concepto': concept, // Nombre del gasto
      'categoria': category,
      'fecha': date,
    };

    // Escribir los datos en el documento
    documentReference.set(datos).then((value) async {
      if (category == 0) {
        await db
            .collection('users')
            .doc(user!.uid)
            .update({'saldo': (currentBalance - amount)});
      } else {
        await db
            .collection('users')
            .doc(user!.uid)
            .update({'saldo': (currentBalance + amount)});
      }
      db.collection('users').doc(user!.uid).update(
        {
          "saldo": FieldValue.increment(
            category == 1
                ? datos["monto"]
                : -datos["monto"]
          ),
        },
      );
    }).catchError((error) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);
    List<String> listItemDropDown =
      [text!.expenses.toString(), text.earnings.toString()];

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            text!.title_addMovement,
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      text.select_a_movement,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: DropdownButton(
                      value: valueItemDropDown,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text(
                            text.expenses,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            text.earnings,
                            style: GoogleFonts.poppins(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ].toList(),
                      onChanged: (newValue) {
                        setState(() {
                          valueItemDropDown = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      text.name_movement,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomIconTextFormField(
                    icon: Icons.money,
                    label: text.concept,
                    controller: concept,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      text.amount_movement,
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomIconTextFormField(
                    icon: Icons.monetization_on,
                    label: text.amount,
                    controller: amount,
                    type: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      text.date_movement,
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
                          child: Icon(Icons.calendar_today),
                        ),
                        Flexible(
                          flex: 1,
                          child: Text(
                            "${datePicked.day}/${datePicked.month}/${datePicked.year}",
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: TextButton(
                            onPressed: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2018, 3, 5),
                                maxTime: DateTime(2029, 6, 7),
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  setState(() {
                                    datePicked = date;
                                  });
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.es,
                              );
                            },
                            child: Text(
                              text.pick_a_date,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
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
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // addMovement();
                        if (valueItemDropDown == listItemDropDown[0]) {
                          addMovement(concept.text, double.parse(amount.text),
                              0, datePicked);
                        } else {
                          addMovement(concept.text, double.parse(amount.text),
                              1, datePicked);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(text.earning_saved_succesfully),
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text.save_button,
                          textAlign: TextAlign.center,
                        ),
                      ],
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

enum TypeMovements { earning, expense }
