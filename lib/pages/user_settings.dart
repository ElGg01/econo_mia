import 'package:econo_mia/ui/theme_mode_option.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';


class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {

  @override
  void initState() {
    super.initState();
    setThemeStringMode();
  }

  late String _themeStringOption;

  void setThemeStringMode(){
    setState(() {
      if (context.read<ThemeProvider>().themeMode == ThemeModeOption.system){
        _themeStringOption = 'System Default';
      } else if (context.read<ThemeProvider>().themeMode == ThemeModeOption.light){
        _themeStringOption = 'Light';
      } else {
        _themeStringOption = 'Dark';
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
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(seconds: 1),
          child: Text("User settings",
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 24
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 30,),
          Column(
            children: [
              Text('Theme',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Choose Theme'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView(
                            shrinkWrap: true,
                            children: <RadioListTile>[
                              RadioListTile(
                                title: const Text('Light'),
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
                                title: const Text('Dark'),
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
                                title: const Text('System Default'),
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
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    title: const Text('Choose Theme'),
                    subtitle: Text(
                      _themeStringOption
                    ),
                  )
                ),
              ),
            ],
          ),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _signOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeData().colorScheme.error,
              ),
              child: const Text('Logout',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
