import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomPageView extends StatefulWidget {
  CustomPageView({
    super.key,
    required this.currentPageView,
    required this.controllerPageView,
    required this.isHorizontal,
    this.years,
  });

  int currentPageView;
  PageController controllerPageView;
  bool isHorizontal;
  List<int>? years;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  Widget _pageItem(String name, int position) {
    TextStyle selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onBackground,
    );
    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
    );

    return Align(
      alignment: Alignment.center,
      child: Text(
        name,
        style: position == widget.currentPageView ? selected : unselected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);
    List<Widget> pagesItemsHorizontal = [
      _pageItem(text!.january, 0),
      _pageItem(text!.february, 1),
      _pageItem(text!.march, 2),
      _pageItem(text!.april, 3),
      _pageItem(text!.may, 4),
      _pageItem(text!.june, 5),
      _pageItem(text!.july, 6),
      _pageItem(text!.august, 7),
      _pageItem(text!.september, 8),
      _pageItem(text!.october, 9),
      _pageItem(text!.november, 10),
      _pageItem(text!.december, 11),
    ];
    List<Widget> pagesItemsVertical = [];

    if (widget.years != null) {
      pagesItemsVertical = widget.years!.asMap().entries.map<Widget>((entry) {
        final year = entry.value;
        final index = entry.key;
        return _pageItem(year.toString(), index);
      }).toList();
    }

    return PageView(
      scrollDirection:
          widget.isHorizontal == true ? Axis.horizontal : Axis.vertical,
      onPageChanged: (newPage) {
        setState(() {
          widget.currentPageView = newPage;
        });
      },
      controller: widget.controllerPageView,
      children: widget.isHorizontal == true
          ? pagesItemsHorizontal
          : pagesItemsVertical,
    );
  }
}
