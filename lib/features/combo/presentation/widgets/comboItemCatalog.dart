import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/core/widgets/button_add_cart_menu.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/combo/presentation/pages/detallecombo.dart';

class ComboItemCatalogo extends StatefulWidget {
  final Combo combo;

  const ComboItemCatalogo({super.key, required this.combo});

  @override
  _ComboItemCatalogoState createState() => _ComboItemCatalogoState();
}

class _ComboItemCatalogoState extends State<ComboItemCatalogo> {
  bool isFavorite = false;

  // Simulando una calificación (puedes reemplazar este valor con la calificación real)
  double rating = 4.5; // Cambia este valor según la calificación que desees

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ComboDetailScreen(combo: widget.combo)),
        );
      },
      child: Card(
        elevation: 5,
        shadowColor: Colors.grey,
        color: Color.fromARGB(255, 255, 253, 253),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 84,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: Image.network(
                      widget.combo.comboImage,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    ).image,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Se asegura que el texto del nombre se ajuste correctamente
                  Expanded(
                    child: Text(
                      widget.combo.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Soluciona el overflow
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? Color.fromARGB(255, 245, 121, 20)
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Manejamos los textos del precio y la moneda con un SizedBox
                  Row(
                    children: [
                      Text(
                        widget.combo.currency,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 245, 121, 20)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.combo.specialPrice.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color.fromARGB(255, 245, 121, 20)),
                      ),
                    ],
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(50),
                    child: ButtonAddCartMenu(
                      combo: widget.combo,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Disponible",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Estrellas y calificación numérica colocadas en un Row
              Row(
                children: [
                  // Estrellas
                  ...List.generate(5, (index) {
                    if (rating >= index + 1) {
                      return const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else if (rating > index) {
                      return const Icon(
                        Icons.star_half,
                        color: Colors.amber,
                        size: 16,
                      );
                    } else {
                      return const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }
                  }),
                  const SizedBox(width: 4),
                  // Calificación numérica
                  Text(
                    "$rating",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
