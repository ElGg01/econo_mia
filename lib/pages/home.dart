import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econo_mia/auth/firebase_auth_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FirebaseFirestore db;

  final FirebaseAuthService _auth = FirebaseAuthService();
  User? user = FirebaseAuth.instance.currentUser;

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
      drawer: Drawer(
        backgroundColor:
            Theme.of(context).colorScheme.background.withOpacity(1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: ListView(
            children: [
              ZoomIn(
                child: Container(
                  child: Image.asset(
                    "assets/logoAppGastosFixed.png",
                    height: 180,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: ElasticIn(
                  child: Text(
                    "EconoMÍA",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElasticInLeft(
                child: ListTile(
                  title: Text(
                    "Mi cuenta",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pushNamed(context, '/user_settings');
                  },
                ),
              ),
              ElasticInLeft(
                delay: const Duration(milliseconds: 500),
                child: ListTile(
                  title: Text(
                    "Cerrar sesión",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    _signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            FadeInDown(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  "Hola, ${user?.displayName}.",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                alignment: Alignment.topCenter,
                width: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              alignment: Alignment.center,
                              value: "Total",
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                  value: "Total",
                                  child: Center(
                                    child: Text("Total"),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "BBVA",
                                  child: Center(
                                    child: Text("BBVA"),
                                  ),
                                ),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Ingresos",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "Egresos",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                    SfCircularChart(
                      legend: const Legend(
                        isVisible: false,
                      ),
                      annotations: <CircularChartAnnotation>[
                        CircularChartAnnotation(
                          height: '100%',
                          width: '100%',
                          widget: Container(
                            child: PhysicalModel(
                              shape: BoxShape.circle,
                              elevation: 10,
                              shadowColor: Colors.black,
                              color: Theme.of(context).colorScheme.background,
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'No hubo ingresos',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        CircularChartAnnotation(
                          widget: Container(),
                        ),
                      ],
                      series: <CircularSeries>[
                        // Renders doughnut chart
                        DoughnutSeries<ChartData, String>(
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
                            ChartData(
                              'Nelo',
                              350.5,
                              Colors.purple,
                            ),
                          ],
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                          color: Colors.cyan.withOpacity(0.5),
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
                                title: const ChartTitle(
                                  text: "Tus cuentas:",
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                          color: Colors.red.withOpacity(0.5),
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
                          color: Colors.green.withOpacity(0.5),
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
