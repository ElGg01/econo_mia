import 'package:flutter/material.dart';

class FuncSnackBar {

  static void showSnackBar(BuildContext context, String text, bool isError){
    final snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          _returnIcon(isError),
          const SizedBox(width: 20,),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _returnColor(context, isError),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Widget _returnIcon(bool isError){
    return isError
      ? const Icon(Icons.dangerous_outlined)
      : const Icon(Icons.info_outline);
  }

  static Color _returnColor(BuildContext context, bool isError){
    return isError
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.primaryContainer;
  }
}