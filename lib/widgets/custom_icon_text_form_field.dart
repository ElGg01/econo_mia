import 'package:flutter/material.dart';

class CustomIconTextFormField extends StatefulWidget {
  const CustomIconTextFormField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
  });

  final IconData icon;
  final String label;
  final TextEditingController controller;

  @override
  State<CustomIconTextFormField> createState() =>
      _CustomIconTextFormFieldState();
}

class _CustomIconTextFormFieldState extends State<CustomIconTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        icon: Icon(widget.icon),
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa al menos una letra.';
        }
        return null; // Retorna null si la validación es exitosa
      },
      //onChanged: (value) => print(widget.controller.text),
    );
  }
}
