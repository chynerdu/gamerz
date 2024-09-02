import 'package:flutter/material.dart';

class GamerzElevatedButton extends StatelessWidget {
  final String label;
  final dynamic onPressed;
  final Color? labelColor;
  final Color? backgroundColor;

  const GamerzElevatedButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.labelColor,
      this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 200),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  color: labelColor ?? Colors.black,
                  fontWeight: FontWeight.w700),
            )));
  }
}

class GamerzGoogleElevatedButton extends StatelessWidget {
  final String label;
  final dynamic onPressed;

  const GamerzGoogleElevatedButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 200),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/google.png', width: 20, height: 20),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  )
                ])));
  }
}

class GamerzElevatedButtonSmall extends StatelessWidget {
  final String label;
  final dynamic onPressed;

  const GamerzElevatedButtonSmall(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minWidth: 108),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            )));
  }
}
