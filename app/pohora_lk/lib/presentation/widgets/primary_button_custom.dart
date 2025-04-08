import 'package:flutter/material.dart';

class PrimaryButtonCustom extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const PrimaryButtonCustom({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: TextStyle(fontSize: 16)),
    );
  }
}
