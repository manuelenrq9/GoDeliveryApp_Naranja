import 'package:flutter/material.dart';

class TrackingStep extends StatelessWidget {
  final String label;
  final String time;
  final bool isActive;

  const TrackingStep({
    required this.label,
    required this.time,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          color: isActive ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(time),
            ],
          ),
        ),
      ],
    );
  }
}
