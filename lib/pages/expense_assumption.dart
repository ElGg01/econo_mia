import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    fetchUserTotalBalance();
    fetchAssumptionsForUser();
  }

  Future<void> fetchUserTotalBalance() async {
    await db.collection('users').doc(user!.uid).get().then((data) {
      setState(() {
        balance = data.data()!['saldo'];
      });
      print("El balance es: ${balance}");
    });
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

      // Actualiza el estado del widget con los nuevos datos
      setState(() {
        assumptionData = newData;
      });
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir
      print('Error fetching assumptions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(
            "EconoMÍA",
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
            return ListTile(
              title: Text(data[
                  'name']), // Suponiendo que haya una clave 'title' en tus datos
              subtitle: Text(
                "${data['expense']} MXN",
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Te quedarian:"),
                  Text(
                    "${balance - data['expense']} MXN",
                  ),
                ],
              ), // Suponiendo que haya una clave 'description' en tus datos
            );
          }),
    );
  }
}
