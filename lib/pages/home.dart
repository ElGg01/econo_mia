import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:econo_mia/widgets/chart_transaction.dart';
import 'package:econo_mia/widgets/custom_drawer.dart';
import 'package:econo_mia/widgets/custom_page_view.dart';
import 'package:econo_mia/widgets/tab_bar_view_item.dart';
import 'package:econo_mia/widgets/transaction_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late FirebaseFirestore db;

  late PageController _controllerPageView;
  late PageController _controllerPageViewVertical;
  int currentPageView = 0;
  int currentPageViewVertical = 0;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final List<String> _offlineData = [];
  User? user = FirebaseAuth.instance.currentUser;

  late double balance = 0;

  @override
  void initState() {
    super.initState();
    _controllerPageView = PageController(
      initialPage: currentPageView,
      viewportFraction: 0.4,
    );
    _controllerPageViewVertical = PageController(
      initialPage: currentPageViewVertical,
      viewportFraction: 0.5,
    );

    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // TODO: Make a listen change
    });
    db = FirebaseFirestore.instance;
    _loadData();
  }

  Future<bool> _checkInternetAvailable() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.mobile)) {
      return false;
    } else if (result.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (result.contains(ConnectivityResult.ethernet)) {
      return true;
    } else {
      return false;
    }
  }

  //Clear locally saved offline data
  Future<void> _clearLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('offlineData');
    setState(() {
      _offlineData.clear();
    });
  }

  Future<void> _loadData() async {
    await db.collection('users').doc(user!.uid).get().then((data) {
      setState(() {
        balance = data.data()!['saldo'];
      });
      print("El balance es: ${balance}");
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);
    final List<ChartData> chartData = [
      ChartData(0, 0),
      ChartData(1, 10),
      ChartData(2, 20),
      ChartData(3, 30),
      ChartData(4, 40),
      ChartData(5, 29),
      ChartData(6, 33),
      ChartData(7, 31),
      ChartData(8, 37),
      ChartData(9, 30),
      ChartData(10, 23),
      ChartData(11, 31),
      ChartData(12, 38),
      ChartData(13, 29),
      ChartData(14, 35),
      ChartData(15, 33),
      ChartData(16, 39),
      ChartData(17, 32),
      ChartData(18, 36),
      ChartData(19, 30),
      ChartData(20, 38),
      ChartData(21, 28),
      ChartData(22, 34),
      ChartData(23, 17),
      ChartData(24, 39),
      ChartData(25, 31),
      ChartData(26, 37),
      ChartData(27, 29),
      ChartData(28, -50),
      ChartData(29, 5),
      ChartData(30, 40),
      ChartData(31, 32),
    ];
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
          FadeInDown(
            child: Text(
              "${text!.hello_homePage}, ${user?.displayName}. 🤑",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          JelloIn(
            child: Text(
              textAlign: TextAlign.center,
              "${text!.totalBalance}:",
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
            ),
          ),
          Divider(),
          SizedBox.fromSize(
            size: Size.fromHeight(70),
            child: CustomPageView(
              currentPageView: currentPageView,
              controllerPageView: _controllerPageView,
              isHorizontal: true,
            ),
          ),
          Divider(),
          SfCartesianChart(
            primaryXAxis: NumericAxis(
              interval: 7,
              minimum: 0,
              maximum: 31,
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.currency(
                symbol: "\$",
              ),
            ),
            series: <CartesianSeries>[
              // Renders line chart
              LineSeries<ChartData, int>(
                dataSource: chartData,
                color: Theme.of(context).colorScheme.primary,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
              ),
            ],
          ),
          Divider(),
          TransactionItemRow(
            icon: Icons.abc,
            name: 'Concepto',
            amount: 100,
            date: '15/05/24',
          ),
          TransactionItemRow(
            icon: Icons.access_alarm,
            name: 'Concepto',
            amount: 100,
            date: '16/04/24',
          ),
          TransactionItemRow(
            icon: Icons.access_alarm,
            name: 'Concepto',
            amount: -100,
            date: '01/01/24',
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
  ChartData(this.x, this.y);
  final int x;
  final double y;
}
