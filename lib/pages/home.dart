import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econo_mia/widgets/custom_drawer.dart';
import 'package:econo_mia/widgets/custom_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late FirebaseFirestore db;
  late bool _isEmailVerified = false;

  late PageController _controllerPageView;
  late PageController _controllerPageViewVertical;
  int currentPageView = 0;
  int currentPageViewVertical = 0;

  User? user = FirebaseAuth.instance.currentUser;

  late double balance = 0;
  late List<int> years = [];
  late int year = years[0];
  late int month = 1;

  late List<ChartData> movements = [];
  List<Map<String, dynamic>> descriptionMovements = [];

  @override
  void initState() {
    super.initState();
    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!_isEmailVerified){
      Navigator.pushReplacementNamed(context, '/email_verification');
    }
    _controllerPageView = PageController(
      initialPage: currentPageView,
      viewportFraction: 0.4,
    );
    _controllerPageViewVertical = PageController(
      initialPage: currentPageViewVertical,
      viewportFraction: 0.5,
    );

    db = FirebaseFirestore.instance;
    _loadData();
    fetchYears();
  }

  void updateYear(int newYear, int index) {
    print("Año actualizado");
    year = newYear;
    print(year);
    fillMonthMovements();
    setState(() {
      currentPageViewVertical = index;
    });
  }

  void updateMonth(int newMonth, int index) {
    print("Mes actualizado");
    month = newMonth + 1;
    print(month);
    fillMonthMovements();
    setState(() {
      currentPageView = index;
    });
  }

  Future<void> fillMonthMovements() async {
    try {
      CollectionReference collectionReference =
      db.collection('users').doc(user!.uid).collection("transactions");
      QuerySnapshot querySnapshot = await collectionReference
          .where(
        'fecha',
        isGreaterThanOrEqualTo: DateTime(year, month, 1),
      )
          .where(
        'fecha',
        isLessThan: DateTime(year, month + 1, 1),
      )
          .get();

      // Mapa para almacenar datos resumidos por día del mes
      // Mapas para almacenar los montos positivos y negativos por día
      Map<int, double> positiveSummary = {};
      Map<int, double> negativeSummary = {};
      descriptionMovements = [];

      querySnapshot.docs.forEach((documento) {
        // Accedemos a los datos de cada documento y los convertimos en un Map<String, dynamic>
        Map<String, dynamic> datos = documento.data() as Map<String, dynamic>;

        // Obtenemos la fecha del documento
        DateTime fechaDocumento = datos['fecha'].toDate();

        // Resumimos la transacción por día
        int dia = fechaDocumento.day;
        int mes = fechaDocumento.month;
        int anio = fechaDocumento.year;
        double monto = datos['monto'].toDouble();
        int tipo = datos["categoria"];
        String concepto = datos["concepto"];
        print(dia);

        // Verificamos si el monto es positivo o negativo y lo almacenamos en el mapa correspondiente
        if (tipo == 1) {
          positiveSummary.update(dia, (value) => value + monto,
              ifAbsent: () => monto);
          descriptionMovements.add({
            'concepto': concepto,
            'monto': monto,
            'fecha': "${dia}/${mes}/${anio}",
          });
          print(descriptionMovements);
        } else {
          negativeSummary.update(dia, (value) => value + monto,
              ifAbsent: () => monto);
          descriptionMovements.add({
            'concepto': concepto,
            'monto': -monto,
            'fecha': "${dia}/${mes}/${anio}",
          });
          print(descriptionMovements);
        }
      });

      setState(() {
        movements = [];
        // Iteramos sobre los días del mes
        for (int day = 1; day <= DateTime(year, month + 1, 0).day; day++) {
          // Obtenemos los montos de ingresos y egresos para el día actual
          double earnings = positiveSummary[day] ?? 0.0;
          double expenses = negativeSummary[day] ?? 0.0;

          // Agregamos los datos a movements
          movements.add(ChartData(day, earnings, expenses));
        }
      });

      // Imprimimos o hacemos lo que necesites con los datos resumidos
      movements.forEach((movement) {
        print(
            'Día: ${movement.x}, ingreso: ${movement.y}, egreso: ${movement.z}');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchYears() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('transactions')
          .get();

      List<int> uniqueYears = [];
      // Recorre los documentos obtenidos
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = data["fecha"].toDate();
        int year = date.year;
        if (!uniqueYears.contains(year)) {
          uniqueYears.add(year);
        }
      });

      uniqueYears.sort();

      // Actualiza el estado del widget con los nuevos datos
      setState(() {
        years = uniqueYears;
        print(years);
      });
      fillMonthMovements();
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir
      print('Error fetching assumptions: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      await db.collection('users').doc(user!.uid).get().then((data) {
        setState(() {
          balance = data.data()!['saldo'];
        });
        print("El balance es: ${balance}");
      });
    } catch (e){
      print("Some error happened");
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);

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
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInDown(
                child: Text(
                  "${text!.hello_homePage}, ${user?.displayName}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
              Column(
                children: [
                  JelloIn(
                    child: Text(
                      textAlign: TextAlign.center,
                      text.totalBalance,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  JelloIn(
                    child: Text(
                      textAlign: TextAlign.center,
                      "${balance} MXN",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox.fromSize(
            size: Size.fromHeight(70),
            child: CustomPageView(
              currentPageView: currentPageViewVertical,
              controllerPageView: _controllerPageViewVertical,
              isHorizontal: false,
              years: years,
              onChange: updateYear,
            ),
          ),
          Divider(),
          SizedBox.fromSize(
            size: Size.fromHeight(70),
            child: CustomPageView(
              currentPageView: currentPageView,
              controllerPageView: _controllerPageView,
              isHorizontal: true,
              onChange: updateMonth,
            ),
          ),
          Divider(),
          SfCartesianChart(
            enableSideBySideSeriesPlacement: false,
            primaryXAxis: NumericAxis(
              interval: 3,
              minimum: 1,
              maximum: movements.length.toDouble(),
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.currency(
                symbol: "\$",
              ),
            ),
            series: <CartesianSeries>[
              // Renders line chart
              ColumnSeries<ChartData, int>(
                dataSource: movements,
                color: Theme.of(context).colorScheme.primary,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
              ColumnSeries<ChartData, int>(
                opacity: 0.9,
                width: 0.4,
                color: Colors.red,
                dataSource: movements,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.z,
              ),
            ],
          ),
          const Divider(),
          Container(
            height: 400,
            child: ListView.separated(
              itemBuilder: (context, index) {
                Map<String, dynamic> movement = descriptionMovements[index];
                return ListTile(
                  title: Text(movement['concepto']),
                  subtitle: Text(
                    "${movement['monto']} MXN",
                    style: TextStyle(
                        color:
                            movement['monto'] < 0 ? Colors.red : Colors.green),
                  ),
                  trailing: Text(movement['fecha']),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: Colors.black,
                height: 2,
              ),
              itemCount: descriptionMovements.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_earning');
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, this.z);
  final int x;
  final double y;
  final double z;
}
