import 'package:econo_mia/auth/authentication_wrapper.dart';
import 'package:econo_mia/auth/change_password.dart';
import 'package:econo_mia/pages/email_verification.dart';
import 'package:econo_mia/ui/theme_mode_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import './ui/color_schemes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:econo_mia/pages/register.dart';
import 'package:econo_mia/pages/login.dart';
import 'package:econo_mia/pages/home.dart';
import 'package:econo_mia/pages/user_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _){
          return MaterialApp(
            title: 'Material App',
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                brightness: Brightness.light
            ),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                brightness: Brightness.dark
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
              '/email_verification': (context) => const EmailVerification(),
              '/home': (context) => const Home(),
              '/user_settings': (context) => const UserSettings(),
              '/user_settings/change_password': (context) => const ChangePassword(),
            },
            initialRoute: "/",
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
            ],
          );
        },
      ),
    );

  }
}
