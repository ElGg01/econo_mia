import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Balance extends StatefulWidget {
  const Balance({super.key});

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

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
            ZoomIn(
              child: SfCircularChart(
                title: const ChartTitle(
                  text: "La distribución de tu dinero:",
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                legend: const Legend(
                  isVisible: true,
                ),
                tooltipBehavior: _tooltipBehavior,
                series: <CircularSeries>[
                  PieSeries<ChartData, String>(
                    enableTooltip: true,
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
                      ChartData(
                        'Nelo',
                        350.5,
                        Colors.purple,
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
                    animationDuration: 1000,
                  ),
                ],
              ),
            ),
            SfCircularChart(
              legend: const Legend(
                isVisible: true,
              ),
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
                    yValueMapper: (ChartData data, _) => data.y)
              ],
            ),
            FlipInX(
              child: Container(
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    "DINERO TOTAL: 1000",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
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
                        color:
                            Colors.black.withOpacity(0.2), // Color de la sombra
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
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
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
