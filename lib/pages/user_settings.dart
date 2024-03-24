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
  }

  late String _themeStringOption;
  late IconData _icon;


  void setThemeStringMode(){
    setState(() {
      if (context.read<ThemeProvider>().themeMode == ThemeModeOption.system){
        _themeStringOption = 'System Default';
        _icon = Icons.computer;
      } else if (context.read<ThemeProvider>().themeMode == ThemeModeOption.light){
        _themeStringOption = 'Light';
        _icon = Icons.light_mode;
      } else {
        _themeStringOption = 'Dark';
        _icon = Icons.dark_mode;
      }
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _deleteAccount() async{
    await _auth.deleteAccount();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text('Are you sure to want to delete the account?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This action cannot be undone'),
              ],
            ),
          ),
          actions: <TextButton>[
            TextButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: _deleteAccount,
              child: const Text('Delete'),
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
            const SizedBox(height: 30,),
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
                  title: Text(user?.displayName ?? "",
                    style: Theme.of(context).textTheme.headlineSmall
                  ),
                  subtitle: Text(user?.email ?? ""),
                  tileColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 30,),
            Text(text.title_heading_account,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10,),
            // Account settings
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                children: <GestureDetector>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, '/user_settings/change_password');
                    },
                    child: ListTile(
                      leading: const Icon(Icons.password),
                      title: Text(text.changePassword_GestureDetector),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Text('Theme',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10,),
            Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(text.chooseTheme_GestureDetector),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: <RadioListTile>[
                              RadioListTile(
                                title: Text(text.light_titleRadialButton),
                                value: ThemeModeOption.light,
                                groupValue: context.read<ThemeProvider>().themeMode,
                                onChanged: (value){
                                  context.read<ThemeProvider>().setThemeMode(value!);
                                  setThemeStringMode();
                                  Navigator.of(context).pop();
                                },
                                hoverColor: Theme.of(context).shadowColor,
                              ),
                              RadioListTile(
                                title: Text(text.dark_titleRadialButton),
                                value: ThemeModeOption.dark,
                                groupValue: context.read<ThemeProvider>().themeMode,
                                onChanged: (value){
                                  context.read<ThemeProvider>().setThemeMode(value!);
                                  setThemeStringMode();
                                  Navigator.of(context).pop();
                                },
                                hoverColor: Theme.of(context).shadowColor,
                              ),
                              RadioListTile(
                                title: Text(text.systemTheme_titleRadialButton),
                                value: ThemeModeOption.system,
                                groupValue: context.read<ThemeProvider>().themeMode,
                                onChanged: (value){
                                  context.read<ThemeProvider>().setThemeMode(value!);
                                  setThemeStringMode();
                                  Navigator.of(context).pop();
                                },
                                hoverColor: Theme.of(context).shadowColor,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text(text.cancelButton_dialog),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  leading: Icon(_icon),
                  title: const Text('Choose Theme'),
                  subtitle: Text(
                      _themeStringOption
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().colorScheme.error,
              ),
              child: const Text('Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                _showDeleteConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().colorScheme.error,
              ),
              child: const Text('Delete Account',
                style: TextStyle(
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
