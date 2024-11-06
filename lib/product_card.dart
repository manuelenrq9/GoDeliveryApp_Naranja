import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              const Text(
                'Popular',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              TextButton(
                onPressed: () {
                  // Acción para ver todos los productos
                },
                child: const Text(
                  'Ver más',
                  style: TextStyle(color:  Color(0xFFFF7000)),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(
                    
          child: Column(
            children: [
              ProductItem(
                imageUrl:
                    'https://www.nestle.com.bd/sites/g/files/pydnoa311/files/koko_0.png',
                name: 'Nestle Koko Krunch Duo (Kids pack)',
                size: '550 gm',
                price: '\$550',
                oldPrice: null,
              ),
              ProductItem(
                imageUrl:
                    'https://sadinbazar.com/wp-content/uploads/2020/12/Rupchanda-Soyabean-Oil-5.jpeg',
                name: 'Rupchanda Soyabean Oil',
                size: '5 litres',
                price: '\$480',
                oldPrice: '\$650',
              ),
              ProductItem(
                imageUrl:
                    'https://www.allservefoodservice.com/wp-content/uploads/2022/01/azucar-zulka.jpeg',
                name: 'azucar-zulka',
                size: '5 litres',
                price: '\$480',
                oldPrice: '\$650',
              ),
              ProductItem(
                imageUrl:
                    'https://costazul.sigo.com.ve/images/thumbs/0009370_maizena-americana-800-gr_450.jpeg',
                name: 'Maizena',
                size: '800 gr',
                price: '\$250',
                oldPrice: '\$550',
              ),ProductItem(
                imageUrl:
                    'https://haciendasantateresa.com.ve/wp-content/uploads/2024/10/ST1796-botella-canister.jpg',
                name: 'Ron SantaTeresa 1796',
                size: '1 litres',
                price: '\$30',
                oldPrice: '\$33',
              ),
            ], 
          ),
        ),
      ],
    );
  }
}

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String size;
  final String price;
  final String? oldPrice;

  const ProductItem({super.key, 
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
                      color:  Color(0xFFFF7000),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.add,
              color: Color(0xFFFF7000),
            ),
          ],
        ),
      ),
    );
  }
}
