import 'package:econo_mia/pages/about.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:econo_mia/pages/add_balance_account.dart';
import 'package:econo_mia/pages/add_earning.dart';
import 'package:econo_mia/pages/add_expense.dart';
import 'package:econo_mia/ui/language_mode_option.dart';
import 'package:econo_mia/auth/forgot_password.dart';
import 'package:econo_mia/pages/balance.dart';
import 'package:econo_mia/auth/authentication_wrapper.dart';
import 'package:econo_mia/auth/change_password.dart';
import 'package:econo_mia/pages/email_verification.dart';
import 'package:econo_mia/ui/theme_mode_option.dart';
import 'package:econo_mia/pages/register.dart';
import 'package:econo_mia/pages/login.dart';
import 'package:econo_mia/pages/home.dart';
import 'package:econo_mia/pages/user_settings.dart';
import './ui/color_schemes.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final languageProvider = Provider.of<LanguageProvider>(context);

        return MaterialApp(
          title: 'Material App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            brightness: Brightness.dark,
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
            '/balance': (context) => const Balance(),
            '/add_balance_account': (context) => const AddBalanceAccount(),
            '/add_earning': (context) => const AddEarning(),
            '/add_expense': (context) => const AddExpense(),
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
