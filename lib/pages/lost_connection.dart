import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LostConnection extends StatelessWidget {
  const LostConnection({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30,),
              const Icon(Icons.wifi_off, size: 200,),
              const SizedBox(height: 30,),
              Text(
                text!.title_lostConnectionPage,
                textAlign: TextAlign.center,
              ),
              Text(
                text.subtitle_lostConnectionPage,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
