import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:animate_do/animate_do.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BounceInDown(
            duration: const Duration(seconds: 1),
            delay: const Duration(seconds: 1),
            child: Text(
              "Tu balance",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SfCircularChart(
                title: const ChartTitle(
                  text: "La distribución de tu dinero:",
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true,
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
                    pointColorMapper: (ChartData data, _) => data.color,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      labelPosition: ChartDataLabelPosition.outside,
                    ),
                    animationDuration: 2000,
                  ),
                ],
              ),
              const Text("Historial de tu efectivo:"),
              FadeInLeft(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer, // Color del contenedor
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color de la sombra
                          spreadRadius: 4, // Radio de propagación de la sombra
                          blurRadius: 4, // Radio de desenfoque de la sombra
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.purple,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.money, color: Colors.white),
                          ),
                        ),
                        const Text(
                          "MONAS CHINAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 180,
                        ),
                        const Text(
                          "-100",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FadeInLeft(
                delay: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer, // Color del contenedor
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color de la sombra
                          spreadRadius: 4, // Radio de propagación de la sombra
                          blurRadius: 4, // Radio de desenfoque de la sombra
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.purple,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.money, color: Colors.white),
                          ),
                        ),
                        const Text(
                          "MONAS CHINAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 180,
                        ),
                        const Text(
                          "-100",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FadeInLeft(
                delay: const Duration(milliseconds: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer, // Color del contenedor
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color de la sombra
                          spreadRadius: 4, // Radio de propagación de la sombra
                          blurRadius: 4, // Radio de desenfoque de la sombra
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.purple,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.money, color: Colors.white),
                          ),
                        ),
                        const Text(
                          "MONAS CHINAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 180,
                        ),
                        const Text(
                          "-100",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              FadeInLeft(
                delay: const Duration(milliseconds: 1500),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer, // Color del contenedor
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color de la sombra
                          spreadRadius: 4, // Radio de propagación de la sombra
                          blurRadius: 4, // Radio de desenfoque de la sombra
                          offset:
                              const Offset(0, 3), // Desplazamiento de la sombra
                        ),
                      ],
                    ),
                    height: 60,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            color: Colors.purple,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.money, color: Colors.white),
                          ),
                        ),
                        const Text(
                          "MONAS CHINAS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 180,
                        ),
                        const Text(
                          "-100",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Historial de tu mercado pago:"),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer, // Color del contenedor
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.5), // Color de la sombra
                        spreadRadius: 4, // Radio de propagación de la sombra
                        blurRadius: 4, // Radio de desenfoque de la sombra
                        offset:
                            const Offset(0, 3), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  height: 60,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          color: Colors.purple,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.money, color: Colors.white),
                        ),
                      ),
                      const Text(
                        "MONAS CHINAS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 180,
                      ),
                      const Text(
                        "-100",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
