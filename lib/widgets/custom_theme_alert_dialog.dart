import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../ui/theme_mode_option.dart';

class CustomThemeAlertDialog extends StatefulWidget {

  final Function setThemeStringMode;

  const CustomThemeAlertDialog({super.key,
    required this.setThemeStringMode,
  });

  @override
  State<CustomThemeAlertDialog> createState() => _CustomThemeAlertDialog();
}


class _CustomThemeAlertDialog extends State<CustomThemeAlertDialog> {



  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(text!.chooseTheme_GestureDetector),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: <RadioListTile>[
            RadioListTile(
              title: Text(text.light_titleRadialButton),
              value: ThemeModeOption.light,
              groupValue:
              context.read<ThemeProvider>().themeMode,
              onChanged: (value) {
                context
                    .read<ThemeProvider>()
                    .setThemeMode(value!);
                widget.setThemeStringMode();
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).shadowColor,
            ),
            RadioListTile(
              title: Text(text.dark_titleRadialButton),
              value: ThemeModeOption.dark,
              groupValue:
              context.read<ThemeProvider>().themeMode,
              onChanged: (value) {
                context
                    .read<ThemeProvider>()
                    .setThemeMode(value!);
                widget.setThemeStringMode();
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).shadowColor,
            ),
            RadioListTile(
              title: Text(text.systemTheme_titleRadialButton),
              value: ThemeModeOption.system,
              groupValue:
              context.read<ThemeProvider>().themeMode,
              onChanged: (value) {
                context
                    .read<ThemeProvider>()
                    .setThemeMode(value!);
                widget.setThemeStringMode();
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).shadowColor,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(text.cancelButton_dialog),
        ),
      ],
    );
  }
}


