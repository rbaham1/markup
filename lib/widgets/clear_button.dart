import 'package:flutter/material.dart';

class ClearButton extends StatelessWidget {
  final VoidCallback onClear;
  const ClearButton({super.key, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onClear,
      icon: Icon(Icons.replay)
    );
  }
}