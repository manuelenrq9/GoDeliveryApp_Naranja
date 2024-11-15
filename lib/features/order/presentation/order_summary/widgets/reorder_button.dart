import 'package:flutter/material.dart';

class ReorderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReorderButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color(0xFFFF9027),
      ),
      child: const Text(
        'Reorder',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
