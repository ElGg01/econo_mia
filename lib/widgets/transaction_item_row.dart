import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionItemRow extends StatefulWidget {
  const TransactionItemRow({
    super.key,
    required this.icon,
    required this.name,
    required this.amount,
  });

  final IconData icon;
  final String name;
  final double amount;

  @override
  State<TransactionItemRow> createState() => _TransactionItemRowState();
}

class _TransactionItemRowState extends State<TransactionItemRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(
              0,
              2,
            ), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(5),
            child: Icon(
              widget.icon,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.name,
              style: GoogleFonts.poppins(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            widget.amount >= 0
                ? ("+" + widget.amount.toString())
                : (widget.amount.toString()),
            style: GoogleFonts.poppins(
              color: widget.amount >= 0 ? (Colors.green) : (Colors.red),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
        ],
      ),
    );
  }
}
