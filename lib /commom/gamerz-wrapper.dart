import 'package:flutter/material.dart';

class GamerzWrapper extends StatelessWidget {
  final dynamic child;

  const GamerzWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(24), child: child);
  }
}
