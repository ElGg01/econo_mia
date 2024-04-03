import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econo_mia/widgets/chart_transaction.dart';
import 'package:econo_mia/widgets/transaction_item_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:econo_mia/auth/firebase_auth_services.dart';

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
  User? user = FirebaseAuth.instance.currentUser;

  late double balance = 0;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    _tabController = TabController(length: 2, vsync: this);
    _earningsSelected = [true, false, false];
    _expensesSelected = [true, false, false];
    _loadData();
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

  // Future<void> loadData() async {
  //   await db.collection('users').get().then((value) {});
  // }

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
                    text!.myAccount_Drawable,
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
                    text!.logOutButton,
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
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: Text(
                  "${text!.hello_homePage}, ${user?.displayName}. 🤑",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            JelloIn(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: Text(
                  "${text!.totalBalance}: ${balance} MXN",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            ElasticInDown(
              child: Padding(
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
                      Container(
                        child: TabBar(
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
                      ),
                      Container(
                        width: double.maxFinite,
                        color: Theme.of(context).colorScheme.background,
                        height: 340,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.5),
                              child: ListView(
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      child: ToggleButtons(
                                        borderRadius: BorderRadius.circular(10),
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderWidth: 5,
                                        selectedBorderColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        isSelected: _earningsSelected,
                                        onPressed: (int index) {
                                          _selectIndex(
                                              index, _earningsSelected);
                                        },
                                        children: [
                                          Text(
                                            "Día",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Mes",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Año",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 250,
                                    child: ZoomIn(
                                      child: ChartTransaction(
                                        text: '5,500 MXN',
                                        data: [
                                          ChartData(
                                            "BBVA",
                                            100,
                                            Colors.red,
                                          ),
                                          ChartData(
                                            "BBVA",
                                            100,
                                            Colors.blue,
                                          ),
                                          ChartData(
                                            "BBVA",
                                            100,
                                            Colors.purple,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Column(
                                    children: [
                                      TransactionItemRow(
                                        icon: Icons.gamepad,
                                        name: "Resident evil 4",
                                        amount: 100,
                                      ),
                                      TransactionItemRow(
                                        icon: Icons.abc,
                                        name: "GTA V",
                                        amount: 1200,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.5),
                              child: ListView(
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.only(top: 10),
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                      child: ToggleButtons(
                                        borderRadius: BorderRadius.circular(10),
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        borderWidth: 5,
                                        selectedBorderColor: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        selectedColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        isSelected: _expensesSelected,
                                        onPressed: (int index) {
                                          _selectIndex(
                                              index, _expensesSelected);
                                        },
                                        children: [
                                          Text(
                                            "Día",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Mes",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Año",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 250,
                                    child: ZoomIn(
                                      child: ChartTransaction(
                                        text: "No hubo egresos",
                                        data: [
                                          ChartData(
                                            "x",
                                            100,
                                            Colors.green,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Column(
                                    children: [
                                      TransactionItemRow(
                                        icon: Icons.boy,
                                        name: "Bebé",
                                        amount: -250,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (_tabController.index == 0) {
                                  Navigator.pushNamed(context, '/add_earning');
                                } else {
                                  Navigator.pushNamed(context, '/add_expense');
                                }
                              },
                              icon: const Icon(Icons.add),
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "© 2024 Los Truchis. Todos los derechos reservados.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
