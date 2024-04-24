import 'package:animate_do/animate_do.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chart_transaction.dart';

class TabBarItemView extends StatefulWidget {
  const TabBarItemView({super.key});

  @override
  State<TabBarItemView> createState() => _TabBarItemViewState();
}

class _TabBarItemViewState extends State<TabBarItemView> {
  late List<bool> _timeSelected;

  @override
  void initState() {
    super.initState();
    _timeSelected = [true, false, false];
  }

  void _selectIndex(int index, List<bool> list) {
    setState(() {
      for (int i = 0; i < list.length; i++) {
        list[i] = (i == index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      child: ListView(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.background,
              ),
              child: ToggleButtons(
                constraints: const BoxConstraints(
                  minWidth: 80,
                  minHeight: 40,
                ),
                borderRadius: BorderRadius.circular(8),
                fillColor: Theme.of(context).colorScheme.tertiary,
                highlightColor: Theme.of(context).colorScheme.tertiary,
                borderColor: Theme.of(context).colorScheme.tertiary,
                borderWidth: 3,
                selectedBorderColor: Theme.of(context).colorScheme.onBackground,
                color: Theme.of(context).colorScheme.onBackground,
                selectedColor: Theme.of(context).colorScheme.background,
                isSelected: _timeSelected,
                onPressed: (int index) {
                  _selectIndex(index, _timeSelected);
                },
                children: [
                  Text(
                    text!.day_toggleButton,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text.week_toggleButton,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    text.month_toggleButton,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 400,
            child: ZoomIn(
              child: ChartTransaction(
                text: '5,500 MXN',
                data: [
                  ChartData(
                    "BBVA",
                    100,
                    Colors.red,
                  ),
                  ChartData(
                    "BBVA",
                    100,
                    Colors.blue,
                  ),
                  ChartData(
                    "BBVA",
                    100,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          const Column(
            children: [],
          ),
        ],
      ),
    );
  }
}
