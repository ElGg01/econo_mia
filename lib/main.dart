import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:econo_mia/pages/add_movement.dart';
import 'package:econo_mia/ui/language_mode_option.dart';
import 'package:econo_mia/auth/forgot_password.dart';
import 'package:econo_mia/auth/authentication_wrapper.dart';
import 'package:econo_mia/auth/change_password.dart';
import 'package:econo_mia/pages/email_verification.dart';
import 'package:econo_mia/ui/theme_mode_option.dart';
import 'package:econo_mia/pages/register.dart';
import 'package:econo_mia/pages/login.dart';
import 'package:econo_mia/pages/home.dart';
import 'package:econo_mia/pages/user_settings.dart';
import 'package:econo_mia/pages/about.dart';
import 'package:econo_mia/pages/add_assumption.dart';
import 'package:econo_mia/pages/expense_assumption.dart';
import './ui/color_schemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? theme = prefs.getString('theme');
  final String? language = prefs.getString('language');
  runApp(App(themeExtracted: theme, languageExtracted: language));
}

class App extends StatefulWidget {
  final String? themeExtracted;
  final String? languageExtracted;
  const App({super.key,
    required this.themeExtracted,
    required this.languageExtracted,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Could not check connectivity status ${e}');
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(widget.themeExtracted),
        ),
        ChangeNotifierProvider(
            create: (context) => LanguageProvider(widget.languageExtracted),
        ),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final languageProvider = Provider.of<LanguageProvider>(context);

        return MaterialApp(
          title: 'Material App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            brightness: Brightness.light,
            fontFamily: 'Poppins',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            brightness: Brightness.dark,
            fontFamily: 'Poppins',
          ),
          themeMode: themeProvider.themeMode == ThemeModeOption.system
              ? ThemeMode.system
              : themeProvider.themeMode == ThemeModeOption.light
                  ? ThemeMode.light
                  : ThemeMode.dark,
          routes: {
            '/': (context) => const AuthenticationWrapper(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(),
            '/about': (context) => const About(),
            '/email_verification': (context) => const EmailVerification(),
            '/forgot_password': (context) => const ForgotPassword(),
            '/home': (context) => const Home(),
            '/user_settings': (context) => const UserSettings(),
            '/user_settings/change_password': (context) =>
                const ChangePassword(),
            '/add_earning': (context) => const AddMovement(),
            '/expense_assumption': (context) => const ExpenseAssumption(),
            '/add_assumption': (context) => const AddAssumption(),
          },
          initialRoute: "/",
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: languageProvider.languageMode == LanguageModeOption.english
              ? const Locale('en')
              : const Locale('es'),
        );
      },
    );
  }
}
