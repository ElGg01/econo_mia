import 'package:flutter/material.dart';

class CustomSettingsSection extends StatelessWidget {

  final String headingText;
  final String gestureDetectorTitle;
  final Widget? gestureDetectorSubTitle;
  final void Function()? onTap;
  final Widget leadingIcon;
  final Widget? trailingIcon;

  const CustomSettingsSection({
    super.key,
    required this.headingText,
    required this.gestureDetectorTitle,
    required this.onTap,
    required this.leadingIcon,
    this.trailingIcon,
    this.gestureDetectorSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10,),
            Text(headingText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // Account settings
        Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            children: <GestureDetector>[
              GestureDetector(
                onTap: onTap,
                child: ListTile(
                  leading: leadingIcon,
                  title: Text(gestureDetectorTitle),
                  subtitle: gestureDetectorSubTitle,
                  trailing: trailingIcon,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
