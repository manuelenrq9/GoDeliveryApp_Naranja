import 'package:flutter/material.dart';
import 'package:godeliveryapp_naranja/features/order/data/cancel_order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartCombo.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/cartProduct.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/order.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderPayment.dart';
import 'package:godeliveryapp_naranja/features/order/domain/entities/orderReport.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_history/widgets/item_names_builder.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_report/make_order_report_screen.dart';
import 'package:godeliveryapp_naranja/features/order/presentation/order_summary/widgets/OrderSummaryScreen.dart';
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

Color getStatusColor(String status) {
  switch (status.toUpperCase()) {
    case 'CREATED':
      return Color.fromARGB(255, 233, 86, 135);
    case 'BEING PROCESSED':
      return Color.fromARGB(255, 98, 91, 190);
    case 'SHIPPED':
      return Color.fromARGB(255, 5, 158, 120);
    case 'DELIVERED':
      return Colors.green;
    case 'CANCELLED':
      return Colors.red;
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
  late Color statusColor = getStatusColor(status);
  String createdDate = '';
  String deliveredDate = '';

  @override
  void initState() {
    super.initState();
    // Convert the string status to an enum
    _status = orderStatusFromString(widget.order.status);
    initializeDateFormatting('es_ES').then((_) {
      setState(() {
        createdDate = formatDate(widget.order.createdDate);
        deliveredDate = formatDate(widget.order.receivedDate);
      });
    });
  }

  String formatDate(DateTime dateTime) {
    // Format the DateTime object into the desired format in Spanish
    return DateFormat('EEE dd MMM yyyy', 'es_ES').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    String orderId = widget.order.id;
    String formatedId = orderId.length > 8 ? orderId.substring(0, 8) : orderId;
    List<CartProduct> products = widget.order.products;
    List<CartCombo> combos = widget.order.combos;
    List<OrderPayment> payment = widget.order.paymentMethod;
    double total = 0;
    String currency = '';
    OrderReport report = widget.order.report[0];
    String reportText = report.description;
    payment.forEach((payment) {
      total = payment.total;
      currency = payment.currency;
    });
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    '$currency ${total.toStringAsFixed(2)}',
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
                  backgroundColor: statusColor,
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
                Wrap(
                  children: [
                    ItemNamesBuilder(products: products, combos: combos),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Tiempo de entrega
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: Colors.grey),
                const SizedBox(width: 4),
                if (status == "DELIVERED")
                  Flexible(
                    child: Text(
                      'Entregado el: $deliveredDate',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (status == "CANCELLED")
                  Flexible(
                    child: Text(
                      'Pedido cancelado',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (status == "BEING PROCESSED")
                  Flexible(
                    child: Text(
                      'tu pedido esta siendo procesado...',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (status == "SHIPPED")
                  Flexible(
                    child: Text(
                      'Tu pedido ha sido enviado a su destino...',
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
            SizedBox(height: 20,),
            Text(reportText),
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
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {cancelOrder(widget.order.id);},
                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                label: const Text(
                  'Cancelar pedido',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(order: widget.order),
                            ),
                          );},
                icon: Icon(Icons.location_on, color: const Color(0xFFFF7000)),
                label: Text(
                  'Hacer seguimiento',
                  style: TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF7000),
                  side: const BorderSide(color: Color(0xFFFF7000)),
                ),
              ),
            ),
          ],
        );
      case OrderStatus.BEING_PROCESSED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                label: const Text(
                  'Cancelar pedido',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(order: widget.order),
                            ),
                          );},
                icon: Icon(Icons.location_on, color: const Color(0xFFFF7000)),
                label: Text(
                  'Hacer seguimiento',
                  style: TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF7000),
                  side: const BorderSide(color: Color(0xFFFF7000)),
                ),
              ),
            ),
          ],
        );
      case OrderStatus.SHIPPED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.cancel, color: Colors.redAccent),
                label: const Text(
                  'Cancelar pedido',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(order: widget.order),
                            ),
                          );},
                icon: Icon(Icons.location_on, color: const Color(0xFFFF7000)),
                label: Text(
                  'Hacer seguimiento',
                  style: TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF7000),
                  side: const BorderSide(color: Color(0xFFFF7000)),
                ),
              ),
            ),
          ],
        );
      case OrderStatus.DELIVERED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh, color: Colors.redAccent),
                label: const Text(
                  'Solicitar reembolso',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              width: 1,
            ),
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_cart, color: const Color(0xFFFF7000)),
                label: Text(
                  'Reordenar',
                  style: TextStyle(fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF7000),
                    side: const BorderSide(color: Color(0xFFFF7000))),
              ),
            ),
          ],
        );
      case OrderStatus.CANCELLED:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MakeOrderReportScreen(order:widget.order),
                            ),
            );
                },
                icon: const Icon(Icons.warning, color: Colors.redAccent),
                label: const Text('Reportar problema'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
          ],
        );
      default:
        return Container(); // Return an empty container if no status matches
    }
  }
}
