import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> signOut() async {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }

    AppLocalizations? text = AppLocalizations.of(context);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(1),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: ListView(
          children: [
            ZoomIn(
              child: Image.asset(
                "assets/logoAppGastosFixed.png",
                height: 180,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.primaryContainer,
              title: ElasticIn(
                child: Text(
                  "EconoMÍA",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElasticInLeft(
              child: ListTile(
                title: Text(
                  text!.myAccount_Drawable,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: const Icon(Icons.person),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/user_settings');
                },
              ),
            ),
            ElasticInLeft(
              child: ListTile(
                title: Text(
                  text!.expense_assumption,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: const Icon(Icons.monetization_on),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/expense_assumption');
                },
              ),
            ),
            ElasticInLeft(
              child: ListTile(
                title: Text(
                  text.about_Drawable,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: const Icon(Icons.info),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ),
            ElasticInLeft(
              delay: const Duration(milliseconds: 500),
              child: ListTile(
                title: Text(
                  text.logOutButton,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                leading: const Icon(Icons.logout),
                onTap: () {
                  signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
