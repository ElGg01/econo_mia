import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseFirestore db;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> loadData() async {
    await db.collection('financial').get().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          delay: const Duration(seconds: 1),
          child: Text(
            "EconoMÍA",
            style: GoogleFonts.roboto(
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
      drawer: Drawer(
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: ListView(
            children: [
              Container(
                child: Image.asset(
                  "assets/logoAppGastosFixed.png",
                  height: 150,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(
                  "EconoMÍA",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text("Mi cuenta"),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.pushNamed(context, '/user_settings');
                },
              ),
              ListTile(
                title: const Text("Cerrar sesión"),
                leading: const Icon(Icons.logout),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            ElasticInLeft(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  bottom: 20,
                  left: 20,
                ),
                child: InkWell(
                  onTapUp: (details) {
                    Navigator.pushNamed(context, '/balance');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 15,
                        sigmaY: 15,
                      ),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.cyan.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 2,
                            color: (Colors.cyanAccent),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: SfCircularChart(
                                title: const ChartTitle(text: "Tus cuentas:"),
                                legend: const Legend(
                                  isVisible: false,
                                ),
                                series: <CircularSeries>[
                                  PieSeries<ChartData, String>(
                                    //SOLO MOSTRAR LOS 5 PRIMEROS CON MAS VALOR
                                    dataSource: <ChartData>[
                                      ChartData(
                                        'Efectivo',
                                        150,
                                        Colors.green,
                                      ),
                                      ChartData(
                                        'Mercado Pago',
                                        250,
                                        Colors.lightBlue,
                                      ),
                                      ChartData(
                                        'BBVA',
                                        500,
                                        Colors.blueAccent,
                                      ),
                                      ChartData(
                                        'Claro Pay',
                                        100,
                                        Colors.red,
                                      ),
                                    ],
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    radius: '70%',
                                    pointColorMapper: (ChartData data, _) =>
                                        data.color,
                                    dataLabelSettings: const DataLabelSettings(
                                      isVisible: true,
                                      labelPosition:
                                          ChartDataLabelPosition.outside,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //SOLO MOSTRAR LOS 5 PRIMEROS CON MAS VALOR
                                const Text(
                                  "RESUMEN:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Efectivo"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.lightBlue,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Mercado Pago"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("BBVA"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text("Claro Pay"),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Text(
                                          "TOTAL: 1000",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Presiono el widget");
                  },
                ),
              ),
            ),
            ElasticInLeft(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, bottom: 20, left: 20),
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 2,
                            color: (Colors.redAccent),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              "assets/logoAppGastosFixed.png",
                              width: 150,
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Text>[
                                Text(
                                  "RESUMEN:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Gasto 1"),
                                Text("Gasto 2"),
                                Text("Gasto 3"),
                                Text("Gasto 4"),
                                Text("Gasto 5"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Presiono el widget");
                  },
                ),
              ),
            ),
            ElasticInLeft(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, bottom: 20, left: 20),
                child: InkWell(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 2,
                            color: (Colors.greenAccent),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              "assets/logoAppGastosFixed.png",
                              width: 150,
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Text>[
                                Text(
                                  "RESUMEN:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Gasto 1"),
                                Text("Gasto 2"),
                                Text("Gasto 3"),
                                Text("Gasto 4"),
                                Text("Gasto 5"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    print("Presiono el widget");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
