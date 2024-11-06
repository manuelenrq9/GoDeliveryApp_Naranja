import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconPath;
    const CategoryCard({
    super.key,
    required this.title,
    required this.iconPath
    });

  @override
  Widget build(BuildContext context) {
    return  Container(
      color:const Color(0xFFFF7000),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50) ),),
      ),
    );
  }
}