import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomIconTextFormField extends StatefulWidget {
  const CustomIconTextFormField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.type = TextInputType.text,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? type;

  @override
  State<CustomIconTextFormField> createState() =>
      _CustomIconTextFormFieldState();
}

class _CustomIconTextFormFieldState extends State<CustomIconTextFormField> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations? text = AppLocalizations.of(context);
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        icon: Icon(widget.icon),
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return text!.please_enter_oneletter;
        }
        return null; // Retorna null si la validación es exitosa
      },
      keyboardType: widget.type,
      //onChanged: (value) => print(widget.controller.text),
    );
  }
}
