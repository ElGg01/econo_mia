import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/user_settings');
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Container(
        color: Colors.white70,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 200,
                              child: SfCircularChart(
                                title: const ChartTitle(text: "Titulo"),
                                legend: const Legend(isVisible: false),
                                series: <CircularSeries>[
                                  PieSeries<ChartData, String>(
                                    dataSource: <ChartData>[
                                      ChartData('India', 280),
                                      ChartData('USA', 210),
                                      ChartData('China', 140),
                                      ChartData('Japan', 120),
                                      ChartData('UK', 90),
                                    ],
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                  ),
                                ],
                              ),
                            ),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
