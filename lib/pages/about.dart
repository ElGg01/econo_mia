import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';


class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(
          duration: const Duration(milliseconds: 800),
          child: Text(
            text!.appbar_about,
            style: GoogleFonts.roboto(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(height: 30,),
              Icon(
                Icons.info,
                size: 200,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Text(
                text.title_aboutPage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 24,
                ),
              ),
              Text(
                text.rights_reserved,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
