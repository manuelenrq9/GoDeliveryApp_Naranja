import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular'),
        actions: [
          TextButton(
            onPressed: () {
              // Acción para ver todos los productos
            },
            child: const Text(
              'View All',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ProductItem(
            imageUrl:
                'https://www.nestle.com.bd/sites/g/files/pydnoa311/files/koko_0.png',
            name: 'Nestle Koko Krunch Duo (Kids pack)',
            size: '550 gm',
            price: '৳ 550',
            oldPrice: null,
          ),
          ProductItem(
            imageUrl:
                'https://sadinbazar.com/wp-content/uploads/2020/12/Rupchanda-Soyabean-Oil-5.jpeg',
            name: 'Rupchanda Soyabean Oil',
            size: '5 litres',
            price: '৳ 480',
            oldPrice: '৳ 650',
          ),
          ProductItem(
            imageUrl:
                'https://www.allservefoodservice.com/wp-content/uploads/2022/01/azucar-zulka.jpeg',
            name: 'azucar-zulka',
            size: '5 litres',
            price: '৳ 480',
            oldPrice: '৳ 650',
          ),
          // Agrega más ProductItem aquí si es necesario
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String size;
  final String price;
  final String? oldPrice;

  const ProductItem({
    required this.imageUrl,
    required this.name,
    required this.size,
    required this.price,
    this.oldPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    size,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (oldPrice != null)
                  Text(
                    oldPrice!,
                    style: const TextStyle(
                      color: Colors.orange,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.add,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
