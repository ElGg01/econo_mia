import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../ui/language_mode_option.dart';

class CustomLanguageAlertDialog extends StatefulWidget {

  final Function setLanguageStringMode;


  const CustomLanguageAlertDialog({super.key,
    required this.setLanguageStringMode
  });

  @override
  State<CustomLanguageAlertDialog> createState() => _CustomLanguageAlertDialogState();
}

class _CustomLanguageAlertDialogState extends State<CustomLanguageAlertDialog> {
  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(text!.chooseLanguage_GestureDetector),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: <RadioListTile>[
            RadioListTile(
              title: Text(text.english_titleRadialButton),
              value: LanguageModeOption.english,
              groupValue:
              context.read<LanguageProvider>().languageMode,
              onChanged: (value) {
                context
                    .read<LanguageProvider>()
                    .setLanguageMode(value!);
                widget.setLanguageStringMode;
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).shadowColor,
            ),
            RadioListTile(
              title: Text(text.spanish_titleRadialButton),
              value: LanguageModeOption.spanish,
              groupValue:
              context.read<LanguageProvider>().languageMode,
              onChanged: (value) {
                context
                    .read<LanguageProvider>()
                    .setLanguageMode(value!);
                widget.setLanguageStringMode();
                Navigator.of(context).pop();
              },
              hoverColor: Theme.of(context).shadowColor,
            ),
          ],
        ),
      ),
    );
  }
}
