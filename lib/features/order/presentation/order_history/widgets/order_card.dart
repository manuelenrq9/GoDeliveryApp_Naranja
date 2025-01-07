import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/item_names_builder.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

enum OrderStatus {
  CREATED,
  BEING_PROCESSED,
  SHIPPED,
  DELIVERED,
  CANCELLED,
}

// Method to convert String to OrderStatus
OrderStatus orderStatusFromString(String status) {
  switch (status.toUpperCase()) {
    case 'CREATED':
      return OrderStatus.CREATED;
    case 'BEING PROCESSED':
      return OrderStatus.BEING_PROCESSED;
    case 'SHIPPED':
      return OrderStatus.SHIPPED;
    case 'DELIVERED':
      return OrderStatus.DELIVERED;
    case 'CANCELLED':
      return OrderStatus.CANCELLED;
    default:
      throw Exception('Unknown status: $status');
  }
}

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
  late String status = widget.order.status;
  late OrderStatus _status = orderStatusFromString(status);
  String createdDate = '';

  @override
  void initState() {
    super.initState();
    // Convert the string status to an enum
    _status = orderStatusFromString(widget.order.status);
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
    String deliveryTime = widget.order.receivedDate.toString();
    List<CartProduct> products = widget.order.products;
    List<CartCombo> combos = widget.order.combos; 
    final bool isDelivered = (status == 'DELIVERED');

    
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
            ButtonsByStatus(),
            /*
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
            ), */
          ],
        ),
      ),
    );
  }

  Widget ButtonsByStatus() {
    switch (_status) {
      case OrderStatus.CREATED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle canceling the order
                print('Order Cancelled');
              },
              child: Text('Cancel Order'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Handle modifying the order
                print('Order Modified');
              },
              child: Text('Modify Order'),
            ),
          ],
        );
      case OrderStatus.BEING_PROCESSED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle contacting support
                print('Contact Support');
              },
              child: Text('Contact Support'),
            ),
          ],
        );
      case OrderStatus.SHIPPED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle tracking the shipment
                print('Tracking Shipment');
              },
              child: Text('Track Shipment'),
            ),
          ],
        );
      case OrderStatus.DELIVERED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle leaving feedback
                print('Leave Feedback');
              },
              child: Text('Leave Feedback'),
            ),
          ],
        );
      case OrderStatus.CANCELLED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle reporting an issue
                print('Report Issue');
              },
              child: Text('Report Issue'),
            ),
          ],
        );
      default:
        return Container(); // Return an empty container if no status matches
    }
  }
}