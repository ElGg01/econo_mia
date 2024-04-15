import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController editingController;
  final IconData icons;
  final String text;
  final String? Function(String?)? validatorFunction;
  final IconButton? iconButton;
  final AutovalidateMode autoValidateMode;
  final bool isObscureText;

  const CustomTextFormField({
    super.key,
    required this.editingController,
    required this.icons,
    required this.text,
    required this.validatorFunction,
    required this.iconButton,
    required this.autoValidateMode,
    required this.isObscureText,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUpBig(
      delay: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: editingController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          labelText: text,
          prefixIcon: Icon(icons),
          suffixIcon: iconButton,
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        autofocus: false,
        obscureText: isObscureText,
        autovalidateMode: autoValidateMode,
        validator: validatorFunction,
      ),
    );
  }
}
