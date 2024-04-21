import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropDownButton extends StatefulWidget {
  CustomDropDownButton({
    super.key,
    required this.dropDownValue,
    required this.elements,
  });

  String dropDownValue;
  List<String> elements;

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButton(
        hint: const Text("Selecciona una cuenta"),
        value: widget.dropDownValue,
        isExpanded: true,
        underline: const SizedBox(),
        items: widget.elements.map((String value) {
          return DropdownMenuItem(
            value: value,
            onTap: () {
              setState(() {
                widget.dropDownValue = value;
              });
            },
            child: Text(
              value,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}
