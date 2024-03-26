import 'package:econo_mia/ui/language_mode_option.dart';
import 'package:econo_mia/widgets/custom_language_alert_dialog.dart';
import 'package:econo_mia/widgets/custom_settings_section.dart';
import 'package:econo_mia/widgets/custom_theme_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:econo_mia/auth/firebase_auth_services.dart';
import 'package:econo_mia/ui/theme_mode_option.dart';


class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    setThemeStringMode();
    setLanguageStringMode();
  }

  late String _themeStringOption;
  late String _languageStringOption;
  late IconData _iconTheme;


  void setThemeStringMode(){
    setState(() {
      if (context.read<ThemeProvider>().themeMode == ThemeModeOption.system) {
        _themeStringOption = 'System Default';
        _iconTheme = Icons.computer;
      } else if (context.read<ThemeProvider>().themeMode ==
          ThemeModeOption.light) {
        _themeStringOption = 'Light';
        _iconTheme = Icons.light_mode;
      } else {
        _themeStringOption = 'Dark';
        _iconTheme = Icons.dark_mode;
      }
    });
  }

  void setLanguageStringMode(){
    setState(() {
      if (context.read<LanguageProvider>().languageMode == LanguageModeOption.english){
        _languageStringOption = "English";
      } else {
        _languageStringOption = "Spanish";
      }
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _deleteAccount() async {
    await _auth.deleteAccount();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {

    AppLocalizations? text = AppLocalizations.of(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text(text!.title_dialog_deleteAccount),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text.subtitle_dialog_deleteAccount),
              ],
            ),
          ),
          actions: <TextButton>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text(text.cancelButton_dialog),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _deleteAccount,
              child: Text(text.deleteButton_dialog),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text(text!.appbar_userSettings,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            // User information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  leading: const Icon(Icons.person_rounded, size: 60),
                  title: Text(
                    user?.displayName ?? "",
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user?.email ?? "",
                    style: (Theme.of(context).textTheme.bodySmall ??
                            const TextStyle())
                        .merge(
                      GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ),
                  tileColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 30,),
            // Change password
            CustomSettingsSection(
              headingText: text.title_heading_account,
              gestureDetectorTitle: text.changePassword_GestureDetector,
              leadingIcon: const Icon(Icons.password),
              trailingIcon: const Icon(Icons.arrow_forward_ios),
              onTap: (){
                Navigator.pushNamed(context, '/user_settings/change_password');
              },
            ),
            const SizedBox(height: 20,),
            // Theme text
            CustomSettingsSection(
              headingText: text.title_heading_theme,
              gestureDetectorTitle: text.chooseTheme_GestureDetector,
              gestureDetectorSubTitle: Text(_themeStringOption == "Light"
                  ? text.light_titleRadialButton
                  : _themeStringOption == "Dark"
                    ? text.dark_titleRadialButton
                    : text.systemTheme_titleRadialButton
              ),
              leadingIcon: Icon(_iconTheme),
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return CustomThemeAlertDialog(setThemeStringMode: setThemeStringMode);
                });
              },
            ),
            const SizedBox(height: 20,),
            // Language
            CustomSettingsSection(
              headingText: text.title_heading_language,
              leadingIcon: const Icon(Icons.language),
              gestureDetectorTitle: text.chooseLanguage_GestureDetector,
              gestureDetectorSubTitle: Text(
                _languageStringOption == "English"
                    ? text.english_titleRadialButton
                    : text.spanish_titleRadialButton
              ),
              onTap: (){
                showDialog(context: context, builder: (BuildContext context){
                  return CustomLanguageAlertDialog(setLanguageStringMode: setLanguageStringMode);
                });
              },
            ),
            const SizedBox(height: 30,),
            // Log Out
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().colorScheme.error,
              ),
              child: Text(text.logOutButton,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            // Delete account
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().colorScheme.error,
              ),
              child: Text(text.deleteAccountButton,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
