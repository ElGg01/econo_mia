import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:econo_mia/widgets/chart_transaction.dart';
import 'package:econo_mia/widgets/custom_drawer.dart';
import 'package:econo_mia/widgets/tab_bar_view_item.dart';
import 'package:econo_mia/widgets/transaction_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late FirebaseFirestore db;

  String dropDownValue = 'Total';

  late TabController _tabController;
  late List<bool> _earningsSelected;
  late List<bool> _expensesSelected;

  final FirebaseAuthService _auth = FirebaseAuthService();
  final List<String> _offlineData = [];
  User? user = FirebaseAuth.instance.currentUser;

  late double balance = 0;

  @override
  void initState() {
    super.initState();
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result){
      // TODO: Make a listen change
    });
    db = FirebaseFirestore.instance;
    _tabController = TabController(length: 2, vsync: this);
    _earningsSelected = [true, false, false];
    _expensesSelected = [true, false, false];
    _loadData();
  }

  Future<bool> _checkInternetAvailable() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.mobile)){
      return false;
    } else if (result.contains(ConnectivityResult.wifi)){
      return true;
    } else if (result.contains(ConnectivityResult.ethernet)){
      return true;
    } else {
      return false;
    }
  }

  // Future<void> _syncData() async {
  //   bool result = await _checkInternetAvailable();
  //   if (!result) return;
  //   _offlineData.forEach((element) {
  //     db.collection(user!.uid).
  //   });
  //   db.collection("users").add(user).then((DocumentReference doc) =>
  //       print('DocumentSnapshot added with ID: ${doc.id}'));
  //   await db.collection("users").doc(user!.uid).set(user.toJSON)
  // }

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

  void _selectIndex(int index, List<bool> list) {
    setState(() {
      for (int i = 0; i < list.length; i++) {
        list[i] = (i == index);
      }
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const SizedBox(height: 20,),
            FadeInDown(
              child: Text(
                "${text!.hello_homePage}, ${user?.displayName}. 🤑",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Theme.of(context).colorScheme.onBackground
                ),
              ),
            ),
            JelloIn(
              child: Text(
                "${text!.totalBalance}: ${balance} MXN",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 50,),
            ElasticInDown(
              child: Container(
                alignment: Alignment.topCenter,
                width: 200,
                height: 800,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .shadow
                          .withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: double.maxFinite,
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
                              value: dropDownValue,
                              borderRadius: BorderRadius.circular(10),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  value: "Total",
                                  onTap: () {
                                    setState(() {
                                      dropDownValue = "Total";
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "Total",
                                      style: GoogleFonts.poppins(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "Efectivo",
                                  onTap: () {
                                    setState(() {
                                      dropDownValue = "Efectivo";
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "Efectivo",
                                      style: GoogleFonts.poppins(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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
                    ),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/add_balance_account');
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        label: Text(
                          text!.addAccount_button,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.background,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor:
                          Theme.of(context).colorScheme.onBackground,
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                      dividerColor:
                          Theme.of(context).colorScheme.background,
                      dividerHeight: 5,
                      indicatorColor:
                          Theme.of(context).colorScheme.onBackground,
                      indicatorWeight: 5,
                      tabs: [
                        Tab(
                          child: Text(
                            text!.earnings,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            text!.expenses,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.maxFinite,
                      color: Theme.of(context).colorScheme.background,
                      height: 600,
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          TabBarItemView(),
                          TabBarItemView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            Navigator.pushNamed(context, '/add_earning');
          } else {
            Navigator.pushNamed(context, '/add_expense');
          }
        },
        child: Icon(Icons.add,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }
}
