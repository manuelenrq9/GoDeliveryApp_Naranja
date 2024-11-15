import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/CatalogoProduct/presentation/widgets/product_card.dart';

class CatalogoPage extends StatelessWidget {
  final List<Map<String, String>> productos = [
    {
      'nombre': 'Producto 1',
      'descripcion': 'Descripción del producto 1',
      'precio': '\$20',
      'imagen':
          'https://lh3.googleusercontent.com/FirLkhJG0YgVeX_aQkP2tF7KWV6_CRHV8fX-9C-isPcpeUwK8MUAHtAruNBCuIds-NZyy9tu-hg3O6xblN5bUsT8wfg5a-aWVTIvMUqJpgDY0Ws'
    },
    {
      'nombre': 'Producto 2',
      'descripcion': 'Descripción del producto 2',
      'precio': '\$35',
      'imagen':
          'https://vallearriba.elplazas.com/media/catalog/product/cache/3e568157972a1320c1e54e4ca9aac161/1/0/10009580un_3.jpg'
    },
    {
      'nombre': 'Producto 3',
      'descripcion': 'Descripción del producto 3',
      'precio': '\$50',
      'imagen':
          'https://lh3.googleusercontent.com/s2czlCvc-LlhnC1d5kOH6_G7e6ykX-hVd2yj47fcE5HE4i6v_w62L7Jb5XkWfoltQGLI2q2lEYjTK1dQuFH_Wm2NYeGasBWT2VPeKAQ1txoIg3Jl'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Catálogo de Productos',
          style: TextStyle(color: Color.fromARGB(255, 175, 91, 7)),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 175, 91, 7), // Cambia el color aquí
        ),
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          return ProductCard(
            nombre: productos[index]['nombre']!,
            descripcion: productos[index]['descripcion']!,
            precio: productos[index]['precio']!,
            imagen: productos[index]['imagen']!,
          );
        },
      ),
    );
  }
}
