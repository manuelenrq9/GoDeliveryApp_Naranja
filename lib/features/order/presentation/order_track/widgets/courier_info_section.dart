import 'package:flutter/material.dart';

class CourierInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                "https://pymstatic.com/5844/conversions/personas-emocionales-wide_webp.webp"),
          ),
          title: const Text(
            "Maria Silva",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          subtitle: Text(
            "Tu Orden",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.phone, color: Color(0xFFFF7000)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.message, color: Color(0xFFFF7000)),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
