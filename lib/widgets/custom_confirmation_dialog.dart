import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String titleDialog;
  final String contentDialog;
  final Function()? deleteFunction;
  const CustomConfirmationDialog({
    super.key,
    required this.titleDialog,
    required this.contentDialog,
    required this.deleteFunction,
  });


  @override
  Widget build(BuildContext context) {

    AppLocalizations? text = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(titleDialog,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(contentDialog,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
      actions: <TextButton>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(text!.cancelButton_dialog),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.background
          ),
          onPressed: () {
            deleteFunction!();
          },
          child: Text(text.deleteButton_dialog),
        ),
      ],
    );
  }
}
