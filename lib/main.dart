import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:econo_mia/pages/summary.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      routes: {
        '/inicio': (context) => const Summary(),
      },
      home: Scaffold(
          appBar: AppBar(
            title: BounceInDown(
              duration: const Duration(seconds: 1),
              delay: const Duration(seconds: 1),
              child: Text("EconoMÍA",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24)),
            ),
            centerTitle: true,
            backgroundColor: Colors.cyan,
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.person))
            ],
          ),
          body: Container(
            color: Colors.white70,
            /* decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/abstract-background.png"),
                    fit: BoxFit.cover)), */
            child: ListView(physics: const BouncingScrollPhysics(), children: [
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
                                    color: Colors.cyan.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        width: 2, color: (Colors.cyanAccent))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/logoAppGastosFixed.png",
                                        width: 150,
                                      ),
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("RESUMEN:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("Gasto 1"),
                                          Text("Gasto 2"),
                                          Text("Gasto 3"),
                                          Text("Gasto 4"),
                                          Text("Gasto 5"),
                                        ],
                                      )
                                    ]),
                              ),
                            )),
                        onTap: () {
                          print("Presiono el widget");
                        },
                      ))),
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
                                        width: 2, color: (Colors.redAccent))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/logoAppGastosFixed.png",
                                        width: 150,
                                      ),
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("RESUMEN:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("Gasto 1"),
                                          Text("Gasto 2"),
                                          Text("Gasto 3"),
                                          Text("Gasto 4"),
                                          Text("Gasto 5"),
                                        ],
                                      )
                                    ]),
                              ),
                            )),
                        onTap: () {
                          print("Presiono el widget");
                        },
                      ))),
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
                                        width: 2, color: (Colors.greenAccent))),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.asset(
                                        "assets/logoAppGastosFixed.png",
                                        width: 150,
                                      ),
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("RESUMEN:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("Gasto 1"),
                                          Text("Gasto 2"),
                                          Text("Gasto 3"),
                                          Text("Gasto 4"),
                                          Text("Gasto 5"),
                                        ],
                                      )
                                    ]),
                              ),
                            )),
                        onTap: () {
                          print("Presiono el widget");
                        },
                      ))),
            ]),
          )),
    );
  }
}

/* import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'EconoMÍA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
} */
