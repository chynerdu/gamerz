import 'package:flutter/material.dart';

class GamerzTextButton extends StatelessWidget {
  final String label;
  final dynamic onPressed;

  const GamerzTextButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
        ));
  }
}
