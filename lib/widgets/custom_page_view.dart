import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  CustomPageView({
    super.key,
    required this.currentPageView,
    required this.controllerPageView,
    required this.isHorizontal,
  });

  int currentPageView;
  PageController controllerPageView;
  bool isHorizontal;

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
    List<Widget> pagesItemsHorizontal = [
      _pageItem("Enero", 0),
      _pageItem("Febrero", 1),
      _pageItem("Marzo", 2),
      _pageItem("Abril", 3),
      _pageItem("Mayo", 4),
      _pageItem("Junio", 5),
      _pageItem("Julio", 6),
      _pageItem("Agosto", 7),
      _pageItem("Septiembre", 8),
      _pageItem("Octubre", 9),
      _pageItem("Noviembre", 10),
      _pageItem("Diciembre", 11),
    ];
    List<Widget> pagesItemsVertical = [
      _pageItem("2024", 0),
      _pageItem("2025", 1),
      _pageItem("2026", 2),
    ];
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
