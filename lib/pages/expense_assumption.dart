import 'package:econo_mia/widgets/custom_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseAssumption extends StatefulWidget {
  const ExpenseAssumption({super.key});

  @override
  State<ExpenseAssumption> createState() => _ExpenseAssumptionState();
}

class _ExpenseAssumptionState extends State<ExpenseAssumption> {
  late FirebaseFirestore db;
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> assumptionData = [];
  late double balance = 0;
  late double totalSumExpenses = 0;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    fetchUserTotalBalance();
    fetchAssumptionsForUser();
    fetchTotalExpenses();
  }

  Future<void> fetchUserTotalBalance() async {
    await db.collection('users').doc(user!.uid).get().then((data) {
      setState(() {
        balance =  double.parse(data.data()!['saldo'].toString());

      });
    });
  }

  Future<void> fetchTotalExpenses() async {
    double totalExpenses = 0;
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('assumption')
          .get();

      querySnapshot.docs.forEach((doc) {
        totalExpenses += double.parse((doc['expense'] ?? 0).toString());
      });

      setState(() {
        totalSumExpenses = totalExpenses;
      });
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir
      print('Error fetching total expenses: $e');
    }
  }

  Future<void> fetchAssumptionsForUser() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('assumption')
          .get();

      List<Map<String, dynamic>> newData = [];
      // Recorre los documentos obtenidos
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        newData.add(data);
      });

      newData.sort((a, b) => b['expense'].compareTo(a['expense']));

      // Actualiza el estado del widget con los nuevos datos
      setState(() {
        assumptionData = newData;
      });
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir
      print('Error fetching assumptions: $e');
    }
  }

  Future<void> deleteAllAssumptions() async {
    // Get a reference to the collection
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('assumption');
    // Get all documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Delete each document
    try {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        print(i);
        await querySnapshot.docs[i].reference.delete();
      }
    } catch (e) {
      print(e);
    }
    await fetchAssumptionsForUser();
    await fetchTotalExpenses();
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> deleteAssumptionItem(int index, String id) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .doc(user!.uid)
          .collection('assumption')
          .get();

      await querySnapshot.docs[index].reference.delete();
      setState(() {
        assumptionData.removeAt(index);
      });
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            text!.expense_assumption,
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
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body: ListView.separated(
          itemCount: assumptionData.length,
          separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                height: 2,
              ),
          itemBuilder: (context, index) {
            Map<String, dynamic> data = assumptionData[index];
            return Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Theme.of(context).colorScheme.error,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.background,
                  size: 32,
                ),
              ),
              secondaryBackground: Container(
                color: Theme.of(context).colorScheme.tertiary,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.edit,
                  color: Theme.of(context).colorScheme.background,
                  size: 32,
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  deleteAssumptionItem(index, data['id']);
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: ListTile(
                  title: Text(
                    data['name'],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ), // Suponiendo que haya una clave 'title' en tus datos
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "- ${data['expense']} MXN",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${(balance - data['expense']).toStringAsFixed(2)} MXN",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context2) {
                  return CustomConfirmationDialog(
                    titleDialog: text.title_deleteAll_Dialog,
                    contentDialog: text.content_delete_dialog,
                    deleteFunction: deleteAllAssumptions,
                  );
                },
                barrierDismissible: false,
              );
            },
            heroTag: "fab2",
            backgroundColor: Theme.of(context).colorScheme.error,
            child: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () async {
              final result =
                  await Navigator.pushNamed(context, '/add_assumption');
              if (result == true) {
                fetchAssumptionsForUser();
                fetchTotalExpenses();
              }
            },
            heroTag: "fab1",
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  text.total_expenses,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  totalSumExpenses.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  text.total_remainders,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                Text(
                  (balance - totalSumExpenses).toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
