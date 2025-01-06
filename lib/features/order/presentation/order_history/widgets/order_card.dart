import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/combo/data/combo_fetchID.dart';
import 'package:godeliveryapp_naranja/features/combo/domain/combo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/item_names_builder.dart';
import 'package:godeliveryapp_naranja/features/product/data/product_fetchID.dart';
import 'package:godeliveryapp_naranja/features/product/domain/entities/product.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {

  String createdDate = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES').then((_){
      setState(() {
        createdDate = formatDate(widget.order.createdDate);
      });
    });
  } 

  String formatDate(DateTime dateTime) {
    // Format the DateTime object into the desired format in Spanish
    return DateFormat('EEE dd MMM yyyy', 'es_ES').format(dateTime);
  }

  num getPrice(){
    num total = 0;
    List<CartProduct> products = widget.order.products;
    products.forEach((product){
      // total += product.price;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    String orderId = widget.order.id;
    String formatedId = orderId.length>8
      ? orderId.substring(0,8) : orderId;
    num price = getPrice();
    String status = widget.order.status;
    final isDelivered = status == 'Delivered';
    String deliveryTime = widget.order.receivedDate.toString();
    List<CartProduct> products = widget.order.products;
    List<CartCombo> combos = widget.order.combos; 

    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fecha y precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    createdDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    '\$$price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // ID del pedido
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Order #$formatedId',
                    style: const TextStyle(
                      color: Color(0xFFFF7000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: isDelivered ? Colors.green : Colors.red,
                ),
              ],
            ),
            const Divider(),
            // Lista de items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(children: [
                  ItemNamesBuilder(products: products, combos: combos),
                ],),
              ],
            ),
            const SizedBox(height: 8),
            // Tiempo de entrega
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    'Entrega estimada: $deliveryTime',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            // Botones de acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isDelivered)
                  Flexible(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.refresh, color: Colors.redAccent),
                      label: const Text('Solicitar reembolso'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                Flexible(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      isDelivered ? Icons.shopping_cart : Icons.error_outline,
                      color: isDelivered
                          ? const Color(0xFFFF7000)
                          : const Color(0xFFB71C1C),
                    ),
                    label: Text(
                      isDelivered ? 'Reordenar' : 'Reportar problema',
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDelivered
                          ? const Color(0xFFFF7000)
                          : const Color(0xFFB71C1C),
                      side: isDelivered
                          ? const BorderSide(color: Color(0xFFFF7000))
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
