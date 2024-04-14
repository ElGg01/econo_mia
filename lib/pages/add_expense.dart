import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econo_mia/widgets/custom_drop_down_button.dart';
import 'package:econo_mia/widgets/custom_icon_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  String dropDownValue = 'MXN';
  Color bgColorSelected = Colors.white;

  late String concept;
  late Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            "Añade un gasto",
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
                    "Selecciona una cuenta:",
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
                  child: CustomDropDownButton(
                    dropDownValue: "Efectivo",
                    elements: ["Efectivo", "BBVA"],
                  ),
                ),
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
                  child: CustomIconTextFormField(
                    icon: Icons.money,
                    label: "Concepto:",
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
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Text(
                    "Categoría:",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: GridView.count(
                    crossAxisCount: 2,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.health_and_safety_outlined),
                              ),
                              Text(
                                "Salud",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.house_outlined),
                              ),
                              Text(
                                "Hogar",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.coffee_outlined),
                              ),
                              Text(
                                "Café",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.book_outlined),
                              ),
                              Text(
                                "Educación",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.star_border_outlined),
                              ),
                              Text(
                                "Ragalos",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.fastfood_outlined),
                              ),
                              Text(
                                "Alimentación",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.family_restroom_outlined),
                              ),
                              Text(
                                "Familia",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightGreenAccent,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.more_time_outlined),
                              ),
                              Text(
                                "Ejercicio",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child:
                                    Icon(Icons.emoji_transportation_outlined),
                              ),
                              Text(
                                "Transporte",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            bgColorSelected = Colors.grey;
                          });
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          color: bgColorSelected,
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                child: Icon(Icons.question_mark_outlined),
                              ),
                              Text(
                                "Otros",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 8,
                  ),
                  child: Text(
                    "Fecha del gasto:",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        locale: LocaleType.es,
                        onChanged: (dateTime) {},
                        onConfirm: (dateTime) {},
                        currentTime: DateTime.now());
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    child: CustomIconTextFormField(
                      icon: Icons.calendar_month_outlined,
                      label: "Seleccione la fecha",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Gasto guardado correctamente"),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Guardar gasto"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
