import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final String iconPath;
    const CategoryCard({
      super.key,
      required this.title,
      required this.iconPath,
    });


  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 73,
        height: 97,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color:const Color(0xFFFF7000),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12,),
            Container(
              width: 49,
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color:const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Image.asset(
                    'images/hamburger.png',
                ),
              ),
            ),
            const SizedBox(height: 5,),
            const Text(
              "Food",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            )
          ],),
       // decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50) ),),
          ),
    );
  }
}
